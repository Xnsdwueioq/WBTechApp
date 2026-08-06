//
// CategoryProductsView.swift
// WBTech
//

import SwiftUI
import UISystem
import OSLog

struct CategoryProductsView: View {
  let route: CategoryRoute
  let service: CatalogServiceProtocol
    
  @State private var viewState = ViewState<[Product]>.idle
  
  var body: some View {
    Group {
      switch viewState {
      case .idle, .loading:
        CategoryProductsContentView(route: route, products: [], isLoading: true)

      case .loaded(let products):
        CategoryProductsContentView(route: route, products: products, isLoading: false)

      case .error(let errorMessage):
        DSErrorView(
          description: errorMessage,
          onRetry: { Task { await loadProducts() } }
        )
      }
    }
    .task {
      await loadProducts()
    }
    .navigationBarBackButtonHidden()
  }
  
  private func loadProducts() async {
    viewState = .loading
    do {
      let products = try await service.fetchProducts(categoryId: route.categoryId)
      viewState = .loaded(products)
    } catch {
      Logger.catalog.error("Error loading products in the category with Id='\(route.categoryId)': \(error.localizedDescription)")
      viewState = .error("Не удалось загрузить товары категории")
    }
  }
}
