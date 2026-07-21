// CartView.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 18.07.2026.

import SwiftUI
import UISystem
import OSLog

struct CartView: View {

  let orderService: OrderServiceProtocol

  @Environment(CartStore.self) private var store

  @State private var address: Address?
  @State private var isOrdering = false

  private enum Configuration {
    static let paymentMethod = "card"
  }

  var body: some View {
    let items = store.cartSummary?.items
    let availableItems = items?.filter { $0.available } ?? []
    let unavailableItems = items?.filter { !$0.available } ?? []
    let quantities = store.quantities

    CartContentView(
      summary: store.cartSummary,
      availableItems: availableItems,
      unavailableItems: unavailableItems,
      quantity: { quantities[$0, default: 0] },
      address: address,
      isOrderEnabled: !availableItems.isEmpty && address != nil && !isOrdering,
      onIncrement: { id in Task { await store.increment(id: id) } },
      onDecrement: { id in Task { await store.remove(id: id) } },
      onOrder: { Task { await createOrder() } },
      onUnavailableTap: { _ in } // TODO: INSERT ACTION
    )
    .task {
      await store.load()
    }
    .task {
      await loadAddress()
    }
  }

  private func loadAddress() async {
    do {
      address = try await orderService.fetchAddresses().first
    } catch {
      Logger.cart.error("Unable to load addresses: \(error.localizedDescription)")
    }
  }

  private func createOrder() async {
    guard let address else { return }

    isOrdering = true
    defer { isOrdering = false }

    do {
      try await orderService.createOrder(
        paymentMethod: Configuration.paymentMethod,
        addressID: address.id
      )
      await store.load()
    } catch {
      Logger.cart.error("Unable to create the order: \(error.localizedDescription)")
    }
  }
}

#Preview {
  CartView(orderService: MockOrderService())
    .environment(CartStore(cartService: MockCartService()))
}
