// CartView.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 18.07.2026.

import SwiftUI
import UISystem
import OSLog

struct CartView: View {

  let orderService: OrderServiceProtocol
  let addressSearchService: AddressSearchServiceProtocol

  @Environment(CartStore.self) private var store
  @Environment(AddressStore.self) private var addressStore

  @State private var presentAddresses = false
  @State private var isOrdering = false
  @State private var isOrderSubmitted = false
  @State private var orderError: CartUserError?

  private enum Configuration {
    static let paymentMethod = "card"
    static let successTitle = "Заказ оформлен"
    static let successSubtitle = "Товары уже в процессе сборки, скоро привезём!"
    static let successButtonName = "Закрыть"
    static let orderErrorTitle = "Не удалось оформить заказ"
    static let alertButtonTitle = "OK"
  }

  var body: some View {
    cartContent
      .fullScreenCover(isPresented: $isOrderSubmitted) {
        DSProgressPreview(
          title: Configuration.successTitle,
          subtitle: Configuration.successSubtitle,
          buttonName: Configuration.successButtonName,
          onClose: { isOrderSubmitted = false }
        )
        .interactiveDismissDisabled()
      }
  }

  private var cartContent: some View {
    let items = store.cartSummary?.items
    let availableItems = items?.filter { $0.available } ?? []
    let unavailableItems = items?.filter { !$0.available } ?? []
    let quantities = store.quantities
    let address = addressStore.selectedAddress

    return CartContentView(
      summary: store.cartSummary,
      availableItems: availableItems,
      unavailableItems: unavailableItems,
      quantity: { quantities[$0, default: 0] },
      address: address,
      isOrderEnabled: !availableItems.isEmpty && address != nil && !isOrdering,
      onIncrement: { id in Task { await store.increment(id: id) } },
      onDecrement: { id in Task { await store.decrement(id: id) } },
      onAddressTap: { presentAddresses = true },
      onOrder: { Task { await createOrder() } },
      onUnavailableTap: { _ in } // TODO: INSERT ACTION
    )
    .task { await addressStore.loadIfNeeded() }
    .sheet(isPresented: $presentAddresses) {
      AddressesListView(
        addressSearchService: addressSearchService
      )
      .environment(addressStore)
    }
    .alert(item: presentedError) { error in
      Alert(
        title: Text(error.title),
        message: Text(error.message),
        dismissButton: .default(Text(Configuration.alertButtonTitle)) {
          orderError = nil
          store.dismissError()
        }
      )
    }
  }

  private var presentedError: Binding<CartUserError?> {
    Binding(
      get: { orderError ?? store.userError },
      set: { newValue in
        if newValue == nil {
          orderError = nil
          store.dismissError()
        }
      }
    )
  }

  private func createOrder() async {
    guard let address = addressStore.selectedAddress else { return }

    isOrdering = true
    defer { isOrdering = false }

    do {
      try await orderService.createOrder(
        paymentMethod: Configuration.paymentMethod,
        addressID: address.id
      )
      isOrderSubmitted = true
      await store.load()
    } catch {
      Logger.cart.error("Unable to create the order: \(error.localizedDescription)")
      orderError = CartUserError(
        title: Configuration.orderErrorTitle,
        message: error.localizedDescription
      )
    }
  }
}

#Preview {
  CartView(
    orderService: MockOrderService(),
    addressSearchService: MockAddressSearchService()
  )
    .environment(CartStore(cartService: MockCartService()))
    .environment(
      AddressStore(
        addresses: [.default],
        selectedAddressID: Address.default.id,
        orderService: MockOrderService()
      )
    )
}
