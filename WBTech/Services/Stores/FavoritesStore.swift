//

import Foundation
import OSLog

@MainActor
@Observable
final class FavoritesStore {
  
  private(set) var overrides: [String: Bool] = [:]
  private let favoritesService: FavoritesServiceProtocol
  
  init(favoritesService: FavoritesServiceProtocol) {
    self.favoritesService = favoritesService
  }
 
  func isFavorite(id: String, fallback: Bool) -> Bool {
    return overrides[id, default: fallback]
  }
  
  func toggle(id: String, current: Bool) async {
    let newStatus = !current
    overrides[id] = newStatus
    do {
      if newStatus {
        try await favoritesService.addToFavorites(id: id)
      } else {
        try await favoritesService.removeFromFavorites(id: id)
      }
    } catch {
      Logger.favorites.error("Status update error: \(error.localizedDescription)")
      overrides[id] = current
    }
  }

  func toggle(id: String, fallback: Bool) async {
    await toggle(id: id, current: isFavorite(id: id, fallback: fallback))
  }
  
}
