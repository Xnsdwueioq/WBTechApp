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
        name: "Энергетик Burn тропический микс",
        weight: 459,
        price: 149,
        rating: 3.8,
        reviewCount: 1356,
        isFavorite: true,
        discount: 0
      ),
      Product(
        id: "product2",
        image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2026/01/4d4df69d-8021-4bea-a5ed-25dc9ebfeb32"),
        name: "Бульмени маленькие с оливковым маслом",
        weight: 800,
        price: 270,
        rating: 4.9,
        reviewCount: 45,
        isFavorite: false,
        discount: 0
      )
    ]
  }
  
  func fetchProduct(id: String) async throws -> ProductDetailed {
    try await Task.sleep(for: .seconds(1))
    
    return ProductDetailed(
      id: id,
      image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/026c8f99-bbe3-40b4-9ef9-3c3759a857ff"),
      name: "Энергетик Burn тропический микс",
      weight: 449.0,
      price: 149,
      rating: 3.8,
      description: """
        Тропический микс — это самый экзотический напиток в семействе Burn. В основе его яркого и многогранного вкуса лежит бодрящая и заводная сладость маракуйи, которая с лёгкостью разожжет любую вечеринку. Неслучайно именно этот напиток мы называем своим самым свежим миксом.
        """,
      isFavorite: true,
      discount: 0.0,
      reviews: [
        Review(rating: 3.2, author: "Антон", createdAt: Date(), content: "ОЧень качественный продукт", images: [])
      ]
    )
  }
  
}
