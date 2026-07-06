//

struct MockFavoritesService: FavoritesServiceProtocol {
  
  func addToFavorites(id: String) async throws { }
  
  func removeFromFavorites(id: String) async throws { }
  
}
