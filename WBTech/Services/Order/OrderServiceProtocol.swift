//

protocol OrderServiceProtocol: Sendable {

  func fetchAddresses() async throws -> [Address]
  func createOrder(paymentMethod: String, addressID: String) async throws -> Void

}
