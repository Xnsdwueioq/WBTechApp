//

import Testing
@testable import WBTech

@MainActor
struct CartStoreTests {
  
  @Test func incrementSuccess() async throws {
    let fake = FakeCartService(quantities: [:])
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
    #expect(store.userError?.title == "Не удалось добавить товар")
  }
  
  @Test func decrementSuccess() async throws {
    let id = "someID"
    let fake = FakeCartService(quantities: [id: 2])
    let store = CartStore(quantities: [id: 2], cartService: fake)
    await store.decrement(id: id)
    
    #expect(await fake.decrementCalls.contains(id))
    #expect(store.quantity(for: id) == 1)
  }
  
  @Test func decrementThrow() async throws {
    let fake = FakeCartService(shouldThrow: true)
    let id = "someID"
    let store = CartStore(quantities: [id: 2], cartService: fake)
    await store.decrement(id: id)
    
    #expect(await fake.decrementCalls.contains(id))
    #expect(store.quantity(for: id) == 2)
    #expect(store.userError?.title == "Не удалось изменить количество")
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

  @Test func cachedQuantitiesRemainAvailableWhenLoadingFails() async throws {
    let persistence = InMemoryCartPersistence(quantities: ["cachedID": 4])
    let store = CartStore(
      cartService: FakeCartService(shouldThrow: true),
      persistence: persistence
    )

    await store.load()

    #expect(store.quantities == ["cachedID": 4])
    #expect(store.cartSummary == nil)
    #expect(store.userError?.title == "Не удалось загрузить корзину")
  }

  @Test func serverCartReplacesAndUpdatesCachedQuantities() async throws {
    let persistence = InMemoryCartPersistence(quantities: ["staleID": 5])
    let store = CartStore(
      cartService: FakeCartService(),
      persistence: persistence
    )

    await store.load()

    let expected = ["idproduct1": 2, "idproduct2": 1]
    #expect(store.quantities == expected)
    #expect(try persistence.loadQuantities() == expected)
  }
  
}
