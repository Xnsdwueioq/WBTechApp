//

protocol OrderServiceProtocol: Sendable {

  func fetchAddresses() async throws -> [Address]
  func createAddress(_ draft: AddressDraft) async throws
  func updateAddress(id: String, draft: AddressDraft) async throws
  func deleteAddress(id: String) async throws
  func createOrder(paymentMethod: String, addressID: String) async throws -> Void

}
