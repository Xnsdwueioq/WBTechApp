//
//  SearchView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/20/26.
//

import SwiftUI
import UISystem
import OSLog

struct SearchView: View {
  let catalogService: CatalogServiceProtocol
  var query: String
  
  @State private var viewState = ViewState<[Product]>.idle
  
  private func filteredProducts(from products: [Product]) -> [Product] {
    guard !query.isEmpty else { return [] }
    return products.filter {
      $0.name.localizedStandardContains(query)
    }
  }
  
  private enum Configuration {
    static let horizontalPadding: CGFloat = 12
  }
  
  var body: some View {
    VStack {
      switch viewState {
      case .idle, .loading:
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)

      case .loaded(let products):
        let results = filteredProducts(from: products)
        if query.isEmpty {
          DSSuggestionToSearchView()
        } else if results.isEmpty {
          ContentUnavailableView.search(text: query)
        } else {
          ProductListView(
            products: results,
            productCardFooterStyle: .standart
          )
          .padding(.horizontal, Configuration.horizontalPadding)
        }

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
  }
  
  private func loadProducts() async {
    viewState = .loading
    do {
      let fetchedProducts = try await catalogService.fetchProducts(categoryId: nil)
      viewState = .loaded(fetchedProducts)
    } catch {
      Logger.search.error("Unable to load the products: \(error.localizedDescription)")
      viewState = .error("Не удалось загрузить товары для поиска")
    }
  }
}
