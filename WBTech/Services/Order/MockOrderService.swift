//

import Foundation

actor MockOrderService: OrderServiceProtocol {

  private var addresses = [Address.default]
  private var orders = [Order.mockActive, Order.mockCompleted]

  func fetchOrders() async throws -> [Order] {
    try await Task.sleep(for: .seconds(0.2))

    return orders
  }

  func fetchAddresses() async throws -> [Address] {
    try await Task.sleep(for: .seconds(0.2))

    return addresses
  }

  func createAddress(_ draft: AddressDraft) async throws {
    try await Task.sleep(for: .seconds(0.3))
    addresses.append(draft.makeAddress(id: UUID().uuidString))
  }

  func updateAddress(id: String, draft: AddressDraft) async throws {
    try await Task.sleep(for: .seconds(0.3))
    guard let index = addresses.firstIndex(where: { $0.id == id }) else { return }
    addresses[index] = draft.makeAddress(id: id)
  }

  func deleteAddress(id: String) async throws {
    try await Task.sleep(for: .seconds(0.3))
    addresses.removeAll { $0.id == id }
  }

  func createOrder(paymentMethod: String, addressID: String) async throws {
    try await Task.sleep(for: .seconds(0.5))
  }

}

extension Order {
  static let mockActive = Order(
    id: "active-order",
    status: .active,
    deliveryDate: nil,
    address: OrderAddress(
      coordinates: Address.default.coordinates,
      addressLine: "Новая Басманная ул., 35 ст1, 59",
      floor: "3",
      entrance: "4",
      intercomCode: "15809",
      comment: "Лифт не работает, извините("
    ),
    orderPrice: 2_330,
    deliveryPrice: 0,
    totalPrice: 2_330,
    totalItems: 4,
    items: mockItems
  )

  static let mockCompleted = Order(
    id: "completed-order",
    status: .completed,
    deliveryDate: "2026-07-15 18:34:00",
    address: mockActive.address,
    orderPrice: mockActive.orderPrice,
    deliveryPrice: mockActive.deliveryPrice,
    totalPrice: mockActive.totalPrice,
    totalItems: mockActive.totalItems,
    items: mockItems
  )

  private static let mockItems = [
    OrderItem(
      id: "product1",
      image: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/026c8f99-bbe3-40b4-9ef9-3c3759a857ff",
      name: "Бутер с колбасой",
      weight: 100,
      price: 900,
      quantity: 1
    ),
    OrderItem(
      id: "product2",
      image: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2026/01/4d4df69d-8021-4bea-a5ed-25dc9ebfeb32",
      name: "Огурец в тесте",
      weight: 80,
      price: 750,
      quantity: 1
    ),
    OrderItem(
      id: "product3",
      image: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/10/5182d418-352d-481c-a6e5-cb479cfcfff3",
      name: "Две печёнки с маслом",
      weight: 100,
      price: 680,
      quantity: 2
    )
  ]
}
