//

protocol CatalogServiceProtocol: Sendable {
  
  func fetchCategories() async throws -> [Category]
  
  func fetchProducts(categoryId: String?) async throws -> [Product]
  
}
