import Testing
@testable import WBTech

@MainActor
struct OrdersStoreTests {

  @Test func loadsAndSplitsOrdersByStatus() async {
    let active = makeOrder(id: "active", status: .active)
    let completed = makeOrder(id: "completed", status: .completed)
    let service = FakeOrderService(
      fetchResults: [],
      orderFetchResults: [.success([active, completed])]
    )
    let store = OrdersStore(orderService: service)

    await store.load()

    #expect(store.activeOrders == [active])
    #expect(store.completedOrders == [completed])
    #expect(store.latestActiveOrder == active)
    #expect(store.getOrder(id: completed.id) == completed)
  }

  @Test func regularLoadDoesNotReloadLoadedOrders() async {
    let active = makeOrder(id: "active", status: .active)
    let service = FakeOrderService(
      fetchResults: [],
      orderFetchResults: [.success([active]), .success([])]
    )
    let store = OrdersStore(orderService: service)

    await store.load()
    await store.load()

    #expect(await service.orderFetchCallCount == 1)
    #expect(store.latestActiveOrder == active)
  }

  @Test func forcedReloadUpdatesOrderWithSameID() async {
    let active = makeOrder(id: "order", status: .active)
    let completed = makeOrder(
      id: "order",
      status: .completed,
      deliveryDate: "2026-07-15 18:34:00"
    )
    let service = FakeOrderService(
      fetchResults: [],
      orderFetchResults: [.success([active]), .success([completed])]
    )
    let store = OrdersStore(orderService: service)

    await store.load()
    await store.load(forceReload: true)

    #expect(store.getOrder(id: "order") == completed)
    #expect(store.activeOrders.isEmpty)
    #expect(store.completedOrders == [completed])
  }

  @Test func exposesLoadingError() async {
    let service = FakeOrderService(
      fetchResults: [],
      orderFetchResults: [.failure]
    )
    let store = OrdersStore(orderService: service)

    await store.load()

    guard case .error = store.state else {
      Issue.record("Expected an error state")
      return
    }
  }

  private func makeOrder(
    id: String,
    status: OrderStatus,
    deliveryDate: String? = nil
  ) -> Order {
    Order(
      id: id,
      status: status,
      deliveryDate: deliveryDate,
      address: OrderAddress(
        coordinates: .init(longitude: 92.87, latitude: 56.01),
        addressLine: "Новая Басманная ул., 35",
        floor: "3",
        entrance: "4",
        intercomCode: "15809",
        comment: nil
      ),
      orderPrice: 900,
      deliveryPrice: 100,
      totalPrice: 1_000,
      totalItems: 1,
      items: []
    )
  }
}
