//

protocol FavoritesServiceProtocol: Sendable {
  
  func addToFavorites(id: String) async throws -> Void
  func removeFromFavorites(id: String) async throws -> Void
  
}
