import Foundation
import OSLog

@MainActor
@Observable
final class OrdersStore {

  private(set) var state: ViewState<[Order]>

  private let orderService: OrderServiceProtocol

  init(
    orders: [Order] = [],
    orderService: OrderServiceProtocol
  ) {
    self.state = orders.isEmpty ? .idle : .loaded(orders)
    self.orderService = orderService
  }

  var activeOrders: [Order] {
    orders.filter { $0.status == .active }
  }

  var completedOrders: [Order] {
    orders.filter { $0.status == .completed }
  }

  var latestActiveOrder: Order? {
    activeOrders.first
  }

  func getOrder(id: String) -> Order? {
    orders.first { $0.id == id }
  }

  func load(forceReload: Bool = false) async {
    guard !state.isLoading else { return }
    if !forceReload, state.value != nil { return }

    state = .loading

    do {
      let orders = try await orderService.fetchOrders()
      state = .loaded(orders)
    } catch {
      Logger.order.error("Unable to load orders: \(error.localizedDescription)")
      state = .error(error.localizedDescription)
    }
  }

  private var orders: [Order] {
    state.value ?? []
  }
}
