//

import SwiftUI
import UISystem
import OSLog

struct CategoryProductsView: View {
  let route: CategoryRoute
  let service: CatalogServiceProtocol
    
  @State private var products: [Product] = []
  @State private var isLoading = true
  
  var body: some View {
    CategoryProductsContentView(route: route, products: products, isLoading: isLoading)
    .task {
      await loadProducts()
    }
    .navigationBarBackButtonHidden()
  }
  
  private func loadProducts() async {
    isLoading = true
    do {
      products = try await service.fetchProducts(categoryId: route.categoryId)
    } catch {
      Logger.catalog.error("Ошибка загрузки продуктов категории с Id='\(route.categoryId)': \(error.localizedDescription)")
    }
    isLoading = false
  }
}
