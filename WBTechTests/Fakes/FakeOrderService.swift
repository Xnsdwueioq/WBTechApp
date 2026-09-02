import Foundation
@testable import WBTech

enum FakeAddressFetchResult: Sendable {
  case success([Address])
  case failure
}

actor FakeOrderService: OrderServiceProtocol {

  private var fetchResults: [FakeAddressFetchResult]

  private(set) var createdDrafts: [AddressDraft] = []
  private(set) var updatedDrafts: [(id: String, draft: AddressDraft)] = []
  private(set) var deletedIDs: [String] = []

  init(fetchResults: [FakeAddressFetchResult]) {
    self.fetchResults = fetchResults
  }

  func fetchAddresses() async throws -> [Address] {
    guard !fetchResults.isEmpty else { return [] }
    switch fetchResults.removeFirst() {
    case .success(let addresses): return addresses
    case .failure: throw TestError.someError
    }
  }

  func createAddress(_ draft: AddressDraft) async throws {
    createdDrafts.append(draft)
  }

  func updateAddress(id: String, draft: AddressDraft) async throws {
    updatedDrafts.append((id, draft))
  }

  func deleteAddress(id: String) async throws {
    deletedIDs.append(id)
  }

  func createOrder(paymentMethod: String, addressID: String) async throws { }
}
