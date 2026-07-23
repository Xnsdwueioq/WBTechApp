//

import SwiftUI
import UISystem
import OSLog

struct FavoritesView: View {
  let catalogService: CatalogServiceProtocol
  
  @State private var isLoading = true
  @State private var products: [Product] = []
  
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
      switch (products.isEmpty, isLoading) {
      case (false, false):
        ProductListView(
          products: products,
          productCardFooterStyle: .compact
        )
        
      case (true, false):
        ContentUnavailableView(
          "Избранное пусто",
          systemImage: "heart",
          description: Text("Добавляйте товары в избранное, и они появятся здесь")
        )
        
      case (_, true):
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    isLoading = true
    defer { isLoading = false }
    do {
      let products = try await catalogService.fetchProducts(categoryId: nil)
      let favorites = products.filter { $0.isFavorite }
      self.products = favorites
    } catch {
      Logger.favorites.error("Error loading products: \(error.localizedDescription)")
    }
  }
}

#Preview {
  FavoritesView(catalogService: MockCatalogService())
    .environment(CartStore(cartService: MockCartService()))
    .environment(FavoritesStore(favoritesService: MockFavoritesService()))
    .environment(ModalRouter())
}
