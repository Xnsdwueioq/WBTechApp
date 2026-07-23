//

protocol CatalogServiceProtocol: Sendable {
  
  func fetchCategories() async throws -> [Category]
  
  func fetchProducts(categoryId: String?) async throws -> [Product]
  
  func fetchProduct(id: String) async throws -> ProductDetailed

  func createReview(productId: String, rating: Int, content: String) async throws

}
