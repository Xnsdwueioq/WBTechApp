//

protocol FavoritesServiceProtocol: Sendable {

  func addToFavorites(id: String) async throws
  func removeFromFavorites(id: String) async throws

}
