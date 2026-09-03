//

import SwiftUI
import OSLog

@main
struct WBTechApp: App {
  let catalogService: CatalogServiceProtocol
  let cartService: CartServiceProtocol
  let favoritesService: FavoritesServiceProtocol
  let orderService: OrderServiceProtocol
  let addressSearchService: AddressSearchServiceProtocol
  let cartPersistence: CartPersistenceProtocol

  init() {
    let isUITesting = ProcessInfo.processInfo.arguments.contains("UITESTS")

    if isUITesting {
      self.catalogService = MockCatalogService()
      self.cartService = MockCartService()
      self.favoritesService = MockFavoritesService()
      self.orderService = MockOrderService()
      self.addressSearchService = MockAddressSearchService()
      self.cartPersistence = InMemoryCartPersistence()
    } else {
      TokenBootstrap.run()
      let token = KeychainStore.read(account: TokenBootstrap.account) ?? ""
      self.catalogService = CatalogService(token: token)
      self.cartService = CartService(token: token)
      self.favoritesService = FavoritesService(token: token)
      self.orderService = OrderService(token: token)
      self.addressSearchService = MapKitAddressSearchService()
      do {
        self.cartPersistence = try SwiftDataCartPersistence()
      } catch {
        Logger.persistence.error("Unable to create the cart storage: \(error.localizedDescription)")
        self.cartPersistence = InMemoryCartPersistence()
      }
    }
  }

  var body: some Scene {
    WindowGroup {
      RootTabView(
        catalogService: catalogService,
        orderService: orderService,
        addressSearchService: addressSearchService,
        cartStore: CartStore(
          cartService: cartService,
          persistence: cartPersistence
        ),
        favoritesStore: FavoritesStore(favoritesService: favoritesService)
      )
    }
  }
}
