//

import Testing
@testable import WBTech

@MainActor
struct CartStoreTests {
  
  @Test func incrementSuccess() async throws {
    let fake = FakeCartService()
    let store = CartStore(cartService: fake)
    let id = "someID"
    await store.increment(id: id)
    
    #expect(await fake.addCalls.contains(id))
    #expect(store.quantity(for: id) == 1)
  }
  
  @Test func incrementThrow() async throws {
    let fake = FakeCartService(shouldThrow: true)
    let id = "someID"
    let store = CartStore(quantities: [id: 3], cartService: fake)

    await store.increment(id: id)
    
    #expect(await fake.addCalls.contains(id))
    #expect(store.quantity(for: id) == 3)
  }
  
  @Test func removeSuccess() async throws {
    let fake = FakeCartService()
    let id = "someID"
    let store = CartStore(quantities: [id: 2], cartService: fake)
    await store.remove(id: id)
    
    #expect(await fake.removeCalls.contains(id))
    #expect(store.quantity(for: id) == 0)
  }
  
  @Test func removeThrow() async throws {
    let fake = FakeCartService(shouldThrow: true)
    let id = "someID"
    let store = CartStore(quantities: [id: 2], cartService: fake)
    await store.remove(id: id)
    
    #expect(await fake.removeCalls.contains(id))
    #expect(store.quantity(for: id) == 2)
  }
  
  @Test func load() async throws {
    let fake = FakeCartService()
    let store = CartStore(cartService: fake)
    
    await store.load()
    
    #expect(store.quantities == ["idproduct1": 2, "idproduct2": 1])
  }
  
  @Test func quantityCheck() async throws {
    let fake = FakeCartService()
    let store = CartStore(cartService: fake)
    
    await store.load()
    let existingQuantity = store.quantity(for: "idproduct1")
    let notExistingQuantity = store.quantity(for: "not existing id")
    
    #expect(existingQuantity == 2)
    #expect(notExistingQuantity == 0)
  }
  
}

