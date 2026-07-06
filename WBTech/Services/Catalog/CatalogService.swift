//

import Foundation

actor CatalogService: CatalogServiceProtocol {

  private let client: Client

  init(token: String) {
    self.client = APIClientFactory.make(token: token)
  }

  func fetchCategories() async throws -> [Category] {
    let response = try await client.getCategories(.init())
    let categories = try response.ok.body.json
    return categories.map(Self.category(from:))
  }

  func fetchProducts(categoryId: String? = nil) async throws -> [Product] {
    let response = try await client.getProducts(.init(query: .init(category: categoryId)))
    let payload = try response.ok.body.json
    return payload.data.map(Self.product(from:))
  }
}

private extension CatalogService {

  static func category(from dto: Components.Schemas.Category) -> Category {
    Category(
      id: dto.id,
      name: dto.name,
      image: URL(string: dto.image)
    )
  }

  static func product(from dto: Components.Schemas.ProductPreview) -> Product {
    Product(
      id: dto.id,
      image: URL(string: dto.image),
      name: dto.name,
      weight: dto.weight,
      price: dto.price,
      rating: Double(dto.rating),
      reviewCount: dto.reviewCount,
      isFavorite: dto.isFavorite,
      discount: dto.discount ?? 0
    )
  }
}
