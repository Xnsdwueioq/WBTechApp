//

import SwiftUI
import UISystem
import OSLog

struct CategoryProductsView: View {
  let route: CategoryRoute
  let service: CatalogServiceProtocol
  
  @Environment(CatalogRouter.self) private var router
  
  @State private var products: [Product] = []
  @State private var isLoading = true
  
  var body: some View {
    VStack {
      Button("Back") { router.pop() } // TODO: move icon to UISystem
      Text(route.groupTitle) // TODO: move titles to UISystem
      Text(route.categoryTitle)
      ScrollView {
        switch isLoading {
        case true:
          ProgressView()
        case false:
          ForEach(products) { product in
            DSProductCardView(config: product.uiConfig, action: {})
          }
        }
      }
      .scrollIndicators(.hidden)
    }
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
