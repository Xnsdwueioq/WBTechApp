//

import SwiftUI
import UISystem

struct RootTabView: View {
  private let catalogService: CatalogServiceProtocol
  private let orderService: OrderServiceProtocol
  private let addressSearchService: AddressSearchServiceProtocol
  
  @State private var cartStore: CartStore
  @State private var addressStore: AddressStore
  @State private var ordersStore: OrdersStore
  @State private var favoritesStore: FavoritesStore
  
  @State private var modalRouter = ModalRouter()
  @State private var selectedTab: AppTab = .catalog

  private enum Configuration {
    static let orderDetailsCornerRadius: CGFloat = 20
  }
  
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
    self.addressStore = AddressStore(orderService: orderService)
    self.ordersStore = OrdersStore(orderService: orderService)
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
          .environment(addressStore)
      } label: {
        Label(AppTab.cart.rawValue, systemImage: "cart")
      }
    }
    .environment(cartStore)
    .environment(addressStore)
    .environment(ordersStore)
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
          .environment(addressStore)
          .environment(modalRouter)
      case .orderDetails(let id):
        orderDetailsView(selection: .id(id))
      case .latestActiveOrder:
        orderDetailsView(selection: .latestActive)
      }
    }
    .task {
      await cartStore.load()
    }
  }

  private func orderDetailsView(
    selection: OrderDetailsSelection
  ) -> some View {
    OrderDetailsContainerView(
      selection: selection,
      ordersStore: ordersStore,
      cartStore: cartStore,
      onClose: { modalRouter.dismiss() },
      onOpenCart: {
        modalRouter.dismiss()
        selectedTab = .cart
      }
    )
    .presentationDetents([.large])
    .presentationDragIndicator(.hidden)
    .presentationCornerRadius(Configuration.orderDetailsCornerRadius)
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
