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
    #expect(!store.isLoading)
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

  @Test func repeatOrderAddsItemsToExistingCart() async throws {
    let fake = FakeCartService(quantities: ["existing": 1])
    let store = CartStore(cartService: fake)
    let items = [
      makeOrderItem(id: "product1", quantity: 2),
      makeOrderItem(id: "product2", quantity: 1)
    ]

    let result = await store.repeatOrder(items: items)

    #expect(result)
    #expect(await fake.addCalls == ["product1", "product1", "product2"])
    #expect(store.quantity(for: "existing") == 1)
    #expect(store.quantity(for: "product1") == 2)
    #expect(store.quantity(for: "product2") == 1)
  }

  @Test func repeatOrderReconcilesPartialFailure() async throws {
    let fake = FakeCartService(
      failAddAtCall: 2,
      quantities: ["existing": 1]
    )
    let store = CartStore(cartService: fake)

    let result = await store.repeatOrder(
      items: [makeOrderItem(id: "product1", quantity: 2)]
    )

    #expect(!result)
    #expect(await fake.addCalls == ["product1", "product1"])
    #expect(store.quantity(for: "existing") == 1)
    #expect(store.quantity(for: "product1") == 1)
    #expect(store.userError?.title == "Не удалось повторить заказ")
  }

  private func makeOrderItem(id: String, quantity: Int) -> OrderItem {
    OrderItem(
      id: id,
      image: "https://example.com/\(id).png",
      name: id,
      weight: 100,
      price: 200,
      quantity: quantity
    )
  }
  
}
