//

import SwiftUI

struct RootTabView: View {
  private let catalogService: CatalogServiceProtocol

  @State private var cartStore: CartStore
  @State private var favoritesStore: FavoritesStore

  @State private var selectedTab: AppTab = .catalog

  init(
    catalogService: CatalogServiceProtocol,
    cartStore: CartStore,
    favoritesStore: FavoritesStore
  ) {
    self.catalogService = catalogService
    self.cartStore = cartStore
    self.favoritesStore = favoritesStore
  }

  var body: some View {
    TabView(selection: $selectedTab) {
      // MARK: - Catalog
      Tab(value: AppTab.catalog) {
        CatalogTabView(catalogService: catalogService)
      } label: {
        Label(AppTab.catalog.rawValue, systemImage: "square.grid.2x2")
      }

      // MARK: - Favourites
      Tab(value: AppTab.favourites) {
        FavoritesTabView()
      } label: {
        Label(AppTab.favourites.rawValue, systemImage: "heart")
      }
    }
    .tabViewBottomAccessory {
      CartAccessoryView()
    }
    .environment(cartStore)
    .environment(favoritesStore)
    .task {
      await cartStore.load()
    }
  }
}

#Preview {
  RootTabView(catalogService: MockCatalogService(), cartStore: CartStore(cartService: MockCartService()), favoritesStore: FavoritesStore(favoritesService: MockFavoritesService()))
}
