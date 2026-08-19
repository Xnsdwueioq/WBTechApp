//

import SwiftUI
import UISystem

struct RootTabView: View {
  private let catalogService: CatalogServiceProtocol
  private let orderService: OrderServiceProtocol
  private let addressSearchService: AddressSearchServiceProtocol
  
  @State private var cartStore: CartStore
  @State private var favoritesStore: FavoritesStore
  
  @State private var modalRouter = ModalRouter()
  @State private var selectedTab: AppTab = .catalog
  
  init(
    catalogService: CatalogServiceProtocol,
    orderService: OrderServiceProtocol,
    addressSearchService: AddressSearchServiceProtocol,
    cartStore: CartStore,
    favoritesStore: FavoritesStore
  ) {
    self.catalogService = catalogService
    self.orderService = orderService
    self.addressSearchService = addressSearchService
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
      
      // MARK: - Search
      Tab(value: AppTab.search, role: .search) {
        SearchTabView(catalogService: catalogService)
      }
      
      // MARK: - Favourites
      Tab(value: AppTab.favourites) {
        FavoritesTabView(catalogService: catalogService)
      } label: {
        Label(AppTab.favourites.rawValue, systemImage: "heart")
      }
      
      // MARK: - Cart
      Tab(value: AppTab.cart) {
        CartView(
          orderService: orderService,
          addressSearchService: addressSearchService
        )
          .environment(cartStore)
      } label: {
        Label(AppTab.cart.rawValue, systemImage: "cart")
      }
    }
    .environment(cartStore)
    .environment(favoritesStore)
    .environment(modalRouter)
    .sheet(item: $modalRouter.sheet, onDismiss: { modalRouter.presentPendingIfNeeded() }) { item in
      switch item {
      case .productDetailed(let product):
        ProductDetailedView(
          catalogService: catalogService,
          id: product.id,
          product: product,
          onOpenCart: { 
            modalRouter.dismiss()
            selectedTab = .cart 
          },
          onError: nil
        )
        .environment(cartStore)
        .environment(favoritesStore)
      case .cart:
        CartView(
          orderService: orderService,
          addressSearchService: addressSearchService
        )
          .environment(cartStore)
      }
    }
    .task {
      await cartStore.load()
    }
  }
}

#Preview {
  RootTabView(
    catalogService: MockCatalogService(),
    orderService: MockOrderService(),
    addressSearchService: MockAddressSearchService(),
    cartStore: CartStore(cartService: MockCartService()),
    favoritesStore: FavoritesStore(favoritesService: MockFavoritesService())
  )
}
