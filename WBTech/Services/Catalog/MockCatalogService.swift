//

import Foundation

actor MockCatalogService: CatalogServiceProtocol {
  
  func fetchCategories() async throws -> [Category] {
    try await Task.sleep(for: .seconds(1.0))
    
    return [
      Category(id: "category1", name: "Любимое из детства", image: URL(string: "https://example.com/mock1.png")),
      Category(id: "category2", name: "Фермерские продукты", image: URL(string: "https://example.com/mock2.png")),
      Category(id: "category3", name: "Сладенькое", image: URL(string: "https://example.com/mock3.png")),
      Category(id: "category4", name: "Готовая еда", image: URL(string: "https://example.com/mock4.png")),
    ]
  }
  
  func fetchProducts() async throws -> [Product] {
    try await Task.sleep(for: .seconds(1.5))
    
    return [
      Product(
        id: "product1",
        image: URL(string: "https://example.com/cucumber.png"),
        name: "Огурец в тесте",
        weight: 80,
        price: 750,
        rating: 3.8,
        reviewCount: 1356,
        isFavorite: false,
        discount: 0
      ),
      Product(
        id: "product2",
        image: URL(string: "https://example.com/breadsausage.png"),
        name: "Будер с колбасов",
        weight: 100,
        price: 900,
        rating: 4.9,
        reviewCount: 45,
        isFavorite: false,
        discount: 0
      )
    ]
  }
  
}
