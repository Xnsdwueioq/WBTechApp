//

import Foundation

enum OrderStatus: String, Hashable, Sendable {
  case active
  case completed
}

struct OrderAddress: Hashable, Sendable {
  let coordinates: AddressCoordinates
  let addressLine: String
  let floor: String?
  let entrance: String?
  let intercomCode: String?
  let comment: String?
}

struct OrderItem: Identifiable, Hashable, Sendable {
  let id: String
  let image: String
  let name: String
  let weight: Int
  let price: Int
  let quantity: Int
}

struct Order: Identifiable, Hashable, Sendable {
  let id: String
  let status: OrderStatus
  let deliveryDate: String?
  let address: OrderAddress
  let orderPrice: Int
  let deliveryPrice: Int
  let totalPrice: Int
  let totalItems: Int
  let items: [OrderItem]
}
