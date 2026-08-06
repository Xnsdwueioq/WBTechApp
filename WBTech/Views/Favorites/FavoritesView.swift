//
// FavoritesView.swift
// WBTech
//

import SwiftUI
import UISystem
import OSLog

struct FavoritesView: View {
  let catalogService: CatalogServiceProtocol
  
  @Environment(FavoritesStore.self) private var favoritesStore
  
  @State private var viewState = ViewState<[Product]>.idle
  
  private enum Configuration {
    static let verticalSpacing: CGFloat = 20
    static let topPadding: CGFloat = 20
    static let horizontalPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 0
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: Configuration.verticalSpacing) {
      HStack {
        Text("Избранное")
          .font(.dsCatalogGroupTitle)
        Spacer()
      }
      switch viewState {
      case .idle, .loading:
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)

      case .loaded(let products):
        if products.isEmpty {
          ContentUnavailableView(
            "Избранное пусто",
            systemImage: "heart",
            description: Text("Добавляйте товары в избранное, и они появятся здесь")
          )
        } else {
          ProductListView(
            products: products,
            productCardFooterStyle: .compact
          )
        }

      case .error(let errorMessage):
        DSErrorView(
          description: errorMessage,
          onRetry: { Task { await loadProducts() } }
        )
      }
    }
    .padding(.top, Configuration.topPadding)
    .padding(.horizontal, Configuration.horizontalPadding)
    .padding(.bottom, Configuration.bottomPadding)
    .task {
      await loadProducts()
    }
  }
  
  private func loadProducts() async {
    viewState = .loading
    do {
      let products = try await catalogService.fetchProducts(categoryId: nil)
      let favorites = products.filter { favoritesStore.isFavorite(id: $0.id, fallback: $0.isFavorite) }
      viewState = .loaded(favorites)
    } catch {
      Logger.favorites.error("Error loading products: \(error.localizedDescription)")
      viewState = .error("Не удалось загрузить избранное")
    }
  }
}

#Preview {
  FavoritesView(catalogService: MockCatalogService())
    .environment(CartStore(cartService: MockCartService()))
    .environment(FavoritesStore(favoritesService: MockFavoritesService()))
    .environment(ModalRouter())
}
