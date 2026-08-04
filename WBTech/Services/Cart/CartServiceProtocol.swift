//

protocol CartServiceProtocol: Sendable {
  
  func fetchCart() async throws -> CartSummary
  func addToCart(id: String) async throws -> Int
  func decrementCartItem(id: String) async throws -> Int
  
}
