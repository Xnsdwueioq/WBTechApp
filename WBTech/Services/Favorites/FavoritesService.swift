//

import Foundation

actor FavoritesService: FavoritesServiceProtocol {
  
  private let client: Client
  
  init(token: String) {
    self.client = APIClientFactory.make(token: token)
  }
  
  func addToFavorites(id: String) async throws {
    let response = try await client.addFavourite(.init(path: .init(id: id)))
    _ = try response.ok
  }
  
  func removeFromFavorites(id: String) async throws {
    let response = try await client.removeFavourite(.init(path: .init(id: id)))
    _ = try response.ok
  }
  
}
