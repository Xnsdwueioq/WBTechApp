//

import Foundation
@testable import WBTech

actor FakeFavoritesService: FavoritesServiceProtocol {
  
  var shouldThrow = false
  
  private(set) var addCalls: [String] = []
  private(set) var removeCalls: [String] = []
  
  init(shouldThrow: Bool = false) {
    self.shouldThrow = shouldThrow
  }
  
  func addToFavorites(id: String) async throws {
    addCalls.append(id)
    if shouldThrow { throw TestError.someError }
  }
  
  func removeFromFavorites(id: String) async throws {
    removeCalls.append(id)
    if shouldThrow { throw TestError.someError }
  }
  
}
