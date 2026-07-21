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
  
  @State private var isLoading = true
  @State private var products: [Product] = []
  
  private var filteredProducts: [Product] {
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
      switch (filteredProducts.isEmpty, isLoading) {
      case (false, false):
        ProductListView(
          products: filteredProducts,
          productCardFooterStyle: .standart
        )
        .padding(.horizontal, Configuration.horizontalPadding)
        
      case (true, false):
        if query.isEmpty {
          EmptyView()
        } else {
          ContentUnavailableView.search(text: query)
        }
        
      case (_, true):
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .task {
      await loadProducts()
    }
  }
  
  private func loadProducts() async {
    isLoading = true
    defer { isLoading = false }
    do {
      let fetchedProducts = try await catalogService.fetchProducts(categoryId: nil)
      products = fetchedProducts
    } catch {
      Logger.search.error("Unable to load the products: \(error.localizedDescription)")
    }
  }
}
