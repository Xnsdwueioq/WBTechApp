import SwiftUI
import UISystem

enum OrderDetailsSelection: Hashable {
  case id(String)
  case latestActive
}

struct OrderDetailsContainerView: View {
  let selection: OrderDetailsSelection
  let ordersStore: OrdersStore
  let cartStore: CartStore
  let onClose: () -> Void
  let onOpenCart: () -> Void

  @State private var isRepeatingOrder = false
  @State private var isReceiptUnavailable = false
  @State private var repeatError: CartUserError?

  private enum Configuration {
    static let loadErrorTitle = "Не удалось загрузить заказ"
    static let missingOrderTitle = "Заказ не найден"
    static let missingOrderDescription = "Обновите список заказов и попробуйте снова"
    static let receiptUnavailableTitle = "Скачивание чека пока недоступно"
    static let receiptUnavailableMessage = "Сервер не предоставляет файл чека для этого заказа."
    static let retryTitle = "Повторить"
    static let alertButtonTitle = "OK"
  }

  var body: some View {
    content
      .task(id: selection) {
        await ordersStore.load(forceReload: true)
      }
      .alert(Configuration.receiptUnavailableTitle, isPresented: $isReceiptUnavailable) {
        Button(Configuration.alertButtonTitle, role: .cancel) {}
      } message: {
        Text(Configuration.receiptUnavailableMessage)
      }
      .alert(item: $repeatError) { error in
        Alert(
          title: Text(error.title),
          message: Text(error.message),
          dismissButton: .default(Text(Configuration.alertButtonTitle))
        )
      }
  }

  @ViewBuilder
  private var content: some View {
    switch ordersStore.state {
    case .idle, .loading:
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    case .loaded:
      if let order = selectedOrder {
        OrderDetailsView(
          order: order,
          isRepeatingOrder: isRepeatingOrder,
          onClose: onClose,
          onDownloadReceipt: { isReceiptUnavailable = true },
          onRepeatOrder: { repeatOrder(order) }
        )
      } else {
        DSErrorView(
          title: Configuration.missingOrderTitle,
          description: Configuration.missingOrderDescription,
          systemImage: "shippingbox",
          buttonTitle: Configuration.retryTitle,
          onRetry: reload
        )
      }
    case .error(let message):
      DSErrorView(
        title: Configuration.loadErrorTitle,
        description: message,
        buttonTitle: Configuration.retryTitle,
        onRetry: reload
      )
    }
  }

  private var selectedOrder: Order? {
    switch selection {
    case .id(let id):
      ordersStore.getOrder(id: id)
    case .latestActive:
      ordersStore.latestActiveOrder
    }
  }

  private func reload() {
    Task {
      await ordersStore.load(forceReload: true)
    }
  }

  private func repeatOrder(_ order: Order) {
    guard !isRepeatingOrder else { return }

    Task {
      isRepeatingOrder = true
      let didRepeatOrder = await cartStore.repeatOrder(items: order.items)
      isRepeatingOrder = false

      if didRepeatOrder {
        onOpenCart()
      } else {
        repeatError = cartStore.userError
        cartStore.dismissError()
      }
    }
  }
}
