//

protocol CatalogServiceProtocol {
  
  func fetchCategories() async throws -> [Category]
  
  func fetchProducts() async throws -> [Product]
  
}
