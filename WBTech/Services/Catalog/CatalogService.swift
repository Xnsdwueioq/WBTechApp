//

import Foundation
import OpenAPIURLSession
import OpenAPIRuntime
import HTTPTypes

//actor CatalogService: CatalogServiceProtocol {
//  
//  private let client: Client
//  
//  init(token: String) {
//    self.client = Client(
//      serverURL: try? Servers.Server1.url() ?? URL(string: "https://eat-and-pay.t02.ru/"),
//      transport: URLSessionTransport(),
//      middlewares: [
//        BearerTokenMiddleware(token: token)
//      ]
//    )
//  }
//  
//  func fetchCategories() async throws -> [Category] {
//    
//  }
//  
//  func fetchProducts(categoryId: String? = nil) async throws -> [Product] {
//    
//  }
//  
//}
