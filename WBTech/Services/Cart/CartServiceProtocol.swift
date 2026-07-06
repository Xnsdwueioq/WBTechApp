//

protocol CartServiceProtocol: Sendable {
  
  func fetchCart() async throws -> CartSummary
  func addToCart(id: String) async throws -> Int
  func removeFromCart(id: String) async throws -> Int
  
}
