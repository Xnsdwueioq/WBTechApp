//

import Foundation

actor MockCatalogService: CatalogServiceProtocol {
  
  private let productsData: [String: (product: Product, detailed: ProductDetailed)] = [
    "product1": (
      product: Product(
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
      detailed: ProductDetailed(
        id: "product1",
        image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/026c8f99-bbe3-40b4-9ef9-3c3759a857ff"),
        name: "Энергетик Burn тропический микс",
        weight: 459.0,
        price: 149,
        rating: 3.8,
        description: """
          Тропический микс — это самый экзотический напиток в семействе Burn. В основе его яркого и многогранного вкуса лежит бодрящая и заводная сладость маракуйи, которая с лёгкостью разожжет любую вечеринку.
          """,
        isFavorite: true,
        discount: 0.0,
        reviews: [
          Review(rating: 4.8, author: "Антон", createdAt: Date(), content: "Очень качественный продукт, бодрит отлично!", images: [])
        ]
      )
    ),
    "product2": (
      product: Product(
        id: "product2",
        image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2026/01/4d4df69d-8021-4bea-a5ed-25dc9ebfeb32"),
        name: "Бульмени маленькие с оливковым маслом",
        weight: 800,
        price: 270,
        rating: 4.9,
        reviewCount: 45,
        isFavorite: false,
        discount: 0
      ),
      detailed: ProductDetailed(
        id: "product2",
        image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2026/01/4d4df69d-8021-4bea-a5ed-25dc9ebfeb32"),
        name: "Бульмени маленькие с оливковым маслом",
        weight: 800.0,
        price: 270,
        rating: 4.9,
        description: """
          Сочные бульмени с отборным фаршем из свинины и говядины, с добавлением оливкового масла первого холодного отжима.
          """,
        isFavorite: false,
        discount: 0.0,
        reviews: [
          Review(rating: 5.0, author: "Мария", createdAt: Date(), content: "Самые вкусные бульмени!", images: [])
        ]
      )
    ),
    "product3": (
      product: Product(
        id: "product3",
        image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/10/5182d418-352d-481c-a6e5-cb479cfcfff3"),
        name: "Шоколад Алёнка молочный",
        weight: 100,
        price: 99,
        rating: 4.7,
        reviewCount: 230,
        isFavorite: true,
        discount: 10
      ),
      detailed: ProductDetailed(
        id: "product3",
        image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/10/5182d418-352d-481c-a6e5-cb479cfcfff3"),
        name: "Шоколад Алёнка молочный",
        weight: 100.0,
        price: 99,
        rating: 4.7,
        description: """
          Классический молочный шоколад с нежным вкусом, изготавливается по традиционной рецептуре.
          """,
        isFavorite: true,
        discount: 10.0,
        reviews: [
          Review(rating: 4.5, author: "Елена", createdAt: Date(), content: "Вкус детства!", images: [])
        ]
      )
    ),
    "product4": (
      product: Product(
        id: "product4",
        image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/8328974e-b485-4eca-8b02-64a6811c1bbe"),
        name: "Чипсы картофельные Lay's с солью",
        weight: 140,
        price: 189,
        rating: 4.5,
        reviewCount: 512,
        isFavorite: false,
        discount: 0
      ),
      detailed: ProductDetailed(
        id: "product4",
        image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/8328974e-b485-4eca-8b02-64a6811c1bbe"),
        name: "Чипсы картофельные Lay's с солью",
        weight: 140.0,
        price: 189,
        rating: 4.5,
        description: """
          Хрустящие картофельные чипсы из натурального отборного картофеля с добавлением морской соли.
          """,
        isFavorite: false,
        discount: 0.0,
        reviews: [
          Review(rating: 4.6, author: "Игорь", createdAt: Date(), content: "Отличные чипсы под фильм", images: [])
        ]
      )
    )
  ]

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
    return Array(productsData.values.map { $0.product })
  }
  
  func fetchProduct(id: String) async throws -> ProductDetailed {
    try await Task.sleep(for: .seconds(0.3))
    if let detailed = productsData[id]?.detailed {
      return detailed
    }
    return productsData["product1"]!.detailed
  }

  func createReview(productId: String, rating: Int, content: String) async throws {
    try await Task.sleep(for: .seconds(0.3))
  }

}

