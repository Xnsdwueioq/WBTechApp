import Foundation
@testable import WBTech

enum FakeAddressFetchResult: Sendable {
  case success([Address])
  case failure
}

enum FakeOrderFetchResult: Sendable {
  case success([Order])
  case failure
}

actor FakeOrderService: OrderServiceProtocol {

  private var fetchResults: [FakeAddressFetchResult]
  private var orderFetchResults: [FakeOrderFetchResult]

  private(set) var createdDrafts: [AddressDraft] = []
  private(set) var updatedDrafts: [(id: String, draft: AddressDraft)] = []
  private(set) var deletedIDs: [String] = []
  private(set) var orderFetchCallCount = 0

  init(
    fetchResults: [FakeAddressFetchResult],
    orderFetchResults: [FakeOrderFetchResult] = [.success([])]
  ) {
    self.fetchResults = fetchResults
    self.orderFetchResults = orderFetchResults
  }

  func fetchOrders() async throws -> [Order] {
    orderFetchCallCount += 1
    guard !orderFetchResults.isEmpty else { return [] }

    switch orderFetchResults.removeFirst() {
    case .success(let orders): return orders
    case .failure: throw TestError.someError
    }
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
