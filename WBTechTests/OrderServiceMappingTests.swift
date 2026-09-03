import Testing
@testable import WBTech

struct OrderServiceMappingTests {

  @Test func mapsActiveOrder() throws {
    let dto = makeOrderDTO(status: .active)

    let order = try #require(OrderService.order(from: dto))

    #expect(order.id == "order1")
    #expect(order.status == .active)
    #expect(order.deliveryDate == nil)
    #expect(order.address.addressLine == "Новая Басманная ул., 35")
    #expect(order.address.coordinates.longitude == 92.87)
    #expect(order.address.coordinates.latitude == 56.01)
    #expect(order.totalPrice == 1_000)
    #expect(order.items == [
      OrderItem(
        id: "product1",
        image: "https://example.com/product.png",
        name: "Товар",
        weight: 100,
        price: 900,
        quantity: 1
      )
    ])
  }

  @Test func mapsCompletedOrderDeliveryDate() throws {
    let dto = makeOrderDTO(
      status: .completed,
      deliveryDate: "2026-09-03T12:30:00Z"
    )

    let order = try #require(OrderService.order(from: dto))

    #expect(order.status == .completed)
    #expect(order.deliveryDate == "2026-09-03T12:30:00Z")
  }

  @Test func rejectsAddressWithInvalidCoordinates() {
    let dto = makeOrderDTO(coordinates: [92.87])

    #expect(OrderService.order(from: dto) == nil)
  }

  private func makeOrderDTO(
    status: Components.Schemas.Order.statusPayload = .active,
    deliveryDate: String? = nil,
    coordinates: [Double] = [92.87, 56.01]
  ) -> Components.Schemas.Order {
    Components.Schemas.Order(
      id: "order1",
      status: status,
      deliveryDate: deliveryDate,
      address: Components.Schemas.Address(
        coordinates: coordinates,
        addressLine: "Новая Басманная ул., 35",
        floor: "3",
        entrance: "4",
        intercomCode: "15809",
        comment: "Позвонить перед доставкой"
      ),
      orderPrice: 900,
      deliveryPrice: 100,
      totalPrice: 1_000,
      totalItems: 1,
      items: [
        Components.Schemas.OrderItem(
          id: "product1",
          image: "https://example.com/product.png",
          name: "Товар",
          weight: 100,
          price: 900,
          quantity: 1
        )
      ]
    )
  }
}
