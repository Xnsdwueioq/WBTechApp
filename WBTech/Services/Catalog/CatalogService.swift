//

import Foundation

actor CatalogService: CatalogServiceProtocol {

  private static let pageSize = 100

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
    var products: [Product] = []
    var page = 1
    var totalPages =  1

    repeat {
      let response = try await client.getProducts(
        .init(query: .init(category: categoryId, page: page, pageSize: Self.pageSize))
      )
      let payload = try response.ok.body.json
      products.append(contentsOf: payload.data.map(Self.product(from:)))
      totalPages = payload.totalPages
      page += 1
    } while page <= totalPages

    return products
  }
  
  func fetchProduct(id: String) async throws -> ProductDetailed {
    let response = try await client.getProduct(.init(path: .init(id: id)))
    let payload = try response.ok.body.json
    return Self.productDetailed(from: payload)
  }

  func createReview(productId: String, rating: Int, content: String) async throws {
    let response = try await client.createReview(
      .init(
        path: .init(id: productId),
        body: .json(.init(rating: rating, content: content, images: []))
      )
    )
    _ = try response.ok
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
  
  static func productDetailed(from dto: Components.Schemas.Product) -> ProductDetailed {
    ProductDetailed(
      id: dto.id,
      image: URL(string: dto.image),
      name: dto.name,
      weight: dto.weight,
      price: dto.price,
      rating: Double(dto.rating),
      description: dto.description,
      isFavorite: dto.isFavorite,
      discount: Double(dto.discount ?? 0.0),
      reviews: dto.reviews?.map(Self.review(from:)) ?? []
    )
  }
  
  static func review(from dto: Components.Schemas.Review) -> Review {
    Review(
      rating: Double(dto.rating),
      author: dto.author,
      createdAt: dto.createdAt,
      content: dto.content,
      images: dto.images.map(URL.init(string:))
    )
  }
  
}
