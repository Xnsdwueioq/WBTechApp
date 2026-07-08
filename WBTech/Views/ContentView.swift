//

import SwiftUI

struct ContentView: View {
  private let catalogService: CatalogServiceProtocol
  
  @State private var cartStore: CartStore
  @State private var favoritesStore: FavoritesStore
  
  @State private var router = CatalogRouter()
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
  
  private enum Configuration {
    static let selectTabAnimationDuration: CGFloat = 0.25
  }
  
  var body: some View {
    NavigationStack(path: $router.path) {
      Group {
        TabsView(selectedTab: selectedTab, onSelect: selectTab)
        switch selectedTab {
        case .forYou:
          Spacer()
        case .catalog:
          CatalogView(catalogService: catalogService)
        case .discounts:
          Spacer()
        case .favourites:
          Spacer()
        case .alreadyOrdered:
          Spacer()
        }
      }
      .navigationDestination(for: CategoryRoute.self) { route in
        CategoryProductsView(route: route, service: catalogService)
      }
    }
    .environment(router)
    .environment(cartStore)
    .environment(favoritesStore)
    .task {
      await cartStore.load()
    }
  }
  
  private func selectTab(_ tab: AppTab) {
    withAnimation(.easeInOut(duration: Configuration.selectTabAnimationDuration)) {
      selectedTab = tab
    }
  }
}

#Preview {
  ContentView(catalogService: MockCatalogService(), cartStore: CartStore(cartService: MockCartService()), favoritesStore: FavoritesStore(favoritesService: MockFavoritesService()))
}
