//

import Testing
@testable import WBTech

@MainActor
struct FavoritesStoreTests {
  
  @Test func isFavoriteFallback() async throws {
    let id = "someID"
    let fake = FakeFavoritesService()
    let store = FavoritesStore(favoritesService: fake)
    
    #expect(store.isFavorite(id: id, fallback: true) == true)
  }
  
  @Test func toggleSuccess() async throws {
    let id = "someID"
    let fake = FakeFavoritesService()
    let store = FavoritesStore(favoritesService: fake)
        
    await store.toggle(id: id, current: false)
    
    #expect(store.isFavorite(id: id, fallback: false) == true)
    #expect(await fake.addCalls.contains(id))
  }

  @Test func toggleThrow() async throws {
    let id = "someID"
    let fake = FakeFavoritesService(shouldThrow: true)
    let store = FavoritesStore(favoritesService: fake)
    
    await store.toggle(id: id, current: true)
    
    #expect(store.isFavorite(id: id, fallback: false) == true)
    #expect(await fake.removeCalls.contains(id))
  }
  
}
