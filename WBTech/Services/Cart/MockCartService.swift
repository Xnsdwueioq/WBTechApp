//

actor MockCartService: CartServiceProtocol {

  private struct CatalogEntry {
    let id: String
    let image: String
    let name: String
    let weight: Int
    let price: Int
    let available: Bool
  }

  private enum Configuration {
    static let deliveryTime = 15
    static let deliveryPrice = 79
    static let freeDeliveryThreshold = 1000
    static let fetchDelay: Duration = .seconds(0.3)
    static let mutationDelay: Duration = .seconds(0.1)
  }

  private let catalog: [CatalogEntry] = [
    CatalogEntry(
      id: "product1",
      image: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/026c8f99-bbe3-40b4-9ef9-3c3759a857ff",
      name: "Энергетик Burn тропический микс",
      weight: 459,
      price: 149,
      available: true
    ),
    CatalogEntry(
      id: "product2",
      image: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2026/01/4d4df69d-8021-4bea-a5ed-25dc9ebfeb32",
      name: "Бульмени маленькие с оливковым маслом",
      weight: 800,
      price: 270,
      available: false
    )
  ]

  private var quantities: [String: Int] = [
    "product1": 2,
    "product2": 1
  ]

  func fetchCart() async throws -> CartSummary {
    try await Task.sleep(for: Configuration.fetchDelay)

    let items = catalog.compactMap { entry -> CartLine? in
      let quantity = quantities[entry.id, default: 0]
      guard quantity > 0 else { return nil }

      return CartLine(
        id: entry.id,
        image: entry.image,
        name: entry.name,
        weight: entry.weight,
        price: entry.price,
        quantity: quantity,
        available: entry.available
      )
    }

    
    let filtered = items.filter { $0.available }
    let filteredId = filtered.map { $0.id }
    let totalItems = quantities.reduce(0) {
      if filteredId.contains($1.key) {
        return $0 + $1.value
      } else {
        return $0
      }
    }
    
    let orderPrice = filtered.reduce(0) { $0 + $1.price * $1.quantity }
    let deliveryPrice = orderPrice >= Configuration.freeDeliveryThreshold ? 0 : Configuration.deliveryPrice
    
    return CartSummary(
      deliveryTime: Configuration.deliveryTime,
      orderPrice: orderPrice,
      deliveryPrice: deliveryPrice,
      totalPrice: orderPrice + deliveryPrice,
      totalItems: totalItems,
      items: filtered
    )
  }

  func addToCart(id: String) async throws -> Int {
    try await Task.sleep(for: Configuration.mutationDelay)
    quantities[id, default: 0] += 1

    return totalItems
  }

  func removeFromCart(id: String) async throws -> Int {
    try await Task.sleep(for: Configuration.mutationDelay)
    quantities[id] = nil

    return totalItems
  }

  private var totalItems: Int {
    quantities.values.reduce(0, +)
  }

}
