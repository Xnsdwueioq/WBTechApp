//

import Foundation

struct MockOrderService: OrderServiceProtocol {

  func fetchAddresses() async throws -> [Address] {
    try await Task.sleep(for: .seconds(0.2))

    return [
      Address.default
    ]
  }

  func createOrder(paymentMethod: String, addressID: String) async throws {
    try await Task.sleep(for: .seconds(0.5))
  }

}
