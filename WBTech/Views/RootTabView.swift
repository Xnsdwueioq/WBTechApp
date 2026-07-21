//

import SwiftUI
import UISystem

struct RootTabView: View {
  private let catalogService: CatalogServiceProtocol

  @State private var cartStore: CartStore
  @State private var favoritesStore: FavoritesStore

  @State private var modalRouter = ModalRouter()
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
        FavoritesTabView(catalogService: catalogService)
      } label: {
        Label(AppTab.favourites.rawValue, systemImage: "heart")
      }
      
      // MARK: - Search
      Tab(value: AppTab.search, role: .search) {
        SearchTabView(catalogService: catalogService)
      }
    }
    .tabViewBottomAccessory(isEnabled: cartStore.hasItems) {
      BottomAccessoryView()
    }
    .environment(cartStore)
    .environment(favoritesStore)
    .environment(modalRouter)
    .sheet(item: $modalRouter.sheet) { item in
      switch item {
      case .productDetailed(let product):
        ProductDetailedView(
          catalogService: catalogService,
          id: product.id,
          product: product,
          onOpenCart: { modalRouter.present(route: .cart) },
          onError: nil
        )
          .environment(cartStore)
          .environment(favoritesStore)
      case .cart:
        CartView()
          .environment(cartStore)
      }
    }
    .task {
      await cartStore.load()
    }
  }
}

#Preview {
  RootTabView(catalogService: MockCatalogService(), cartStore: CartStore(cartService: MockCartService()), favoritesStore: FavoritesStore(favoritesService: MockFavoritesService()))
}
