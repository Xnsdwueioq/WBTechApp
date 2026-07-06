//

actor MockCartService: CartServiceProtocol {
  
  var quantities: [String: Int] = [
    "product1": 2,
    "product2": 1
  ]
  
  func fetchCart() async throws -> CartSummary {
    try await Task.sleep(for: .seconds(0.3))
    return CartSummary(
      deliveryTime: 15,
      orderPrice: 568,
      deliveryPrice: 79,
      totalPrice: 647,
      totalItems: 3,
      items: [
        .init(id: "product1", image: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/026c8f99-bbe3-40b4-9ef9-3c3759a857ff", name: "Burn зеленый", weight: 459, price: 149, quantity: quantities["product1", default: 2], available: true),
        .init(id: "product2", image: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2026/01/4d4df69d-8021-4bea-a5ed-25dc9ebfeb32", name: "Бульмени маленькие с оливковым маслом", weight: 800, price: 270, quantity: quantities["product2", default: 1], available: false)
      ]
    )
  }
  
  func addToCart(id: String) async throws -> Int {
    try await Task.sleep(for: .seconds(0.1))
    quantities[id, default: 0] += 1
    return quantities[id] ?? 0
  }
  
  func removeFromCart(id: String) async throws -> Int {
    try await Task.sleep(for: .seconds(0.1))
    quantities[id] = 0
    return quantities[id, default: 0]
  }
  
}
