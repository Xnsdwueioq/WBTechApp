//

import Foundation

struct MockOrderService: OrderServiceProtocol {

  func fetchAddresses() async throws -> [Address] {
    try await Task.sleep(for: .seconds(0.2))

    return [
      Address(
        id: "address1",
        addressLine: "Новая Басманная ул., 35 ст1, 59",
        floor: "3",
        entrance: "4",
        intercomCode: "15809"
      )
    ]
  }

  func createOrder(paymentMethod: String, addressID: String) async throws {
    try await Task.sleep(for: .seconds(0.5))
  }

}
