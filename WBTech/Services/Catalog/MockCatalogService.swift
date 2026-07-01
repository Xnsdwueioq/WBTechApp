//

import Foundation

actor MockCatalogService: CatalogServiceProtocol {
  
  func fetchCategories() async throws -> [Category] {
    try await Task.sleep(for: .seconds(0.1))
    
    return [
      Category(id: "category1", name: "Любимое из детства", image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/701bc980-12cd-4ff7-9d80-0da97846384f")),
      Category(id: "category2", name: "Фермерские продукты", image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/8328974e-b485-4eca-8b02-64a6811c1bbe")),
      Category(id: "category3", name: "Сладенькое", image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/10/5182d418-352d-481c-a6e5-cb479cfcfff3")),
      Category(id: "category4", name: "Готовая еда", image: URL(string: "https://0cdfd2bd-ded8-48d8-a8b1-11fc82cb0381.selstorage.ru/combo_set_card/photo/be73dd41-b9b7-44c2-b629-a2fc4d72a24a.jpg")),
    ]
  }
  
  func fetchProducts(categoryId: String? = nil) async throws -> [Product] {
    try await Task.sleep(for: .seconds(0.2))
    
    return [
      Product(
        id: "product1",
        image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/026c8f99-bbe3-40b4-9ef9-3c3759a857ff"),
        name: "Огурец в тесте c соусом",
        weight: 80,
        price: 750,
        rating: 3.8,
        reviewCount: 1356,
        isFavorite: false,
        discount: 0
      ),
      Product(
        id: "product2",
        image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2026/01/4d4df69d-8021-4bea-a5ed-25dc9ebfeb32"),
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
