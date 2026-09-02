//

import Foundation

actor MockOrderService: OrderServiceProtocol {

  private var addresses = [Address.default]

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
