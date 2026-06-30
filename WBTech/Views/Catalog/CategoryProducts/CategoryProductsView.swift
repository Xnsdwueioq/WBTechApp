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
      CategoryProductsHeaderView(
        groupTitle: route.groupTitle,
        categoryTitle: route.categoryTitle,
        onTapBack: { router.pop() }
      )
      ProductListView(
        products: products,
        isLoading: isLoading,
        onFavoriteTap: { },
        onAddToCart: { }
      )
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
