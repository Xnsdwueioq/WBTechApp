//

import SwiftUI
import OSLog

@main
struct WBTechApp: App {
  let catalogService: CatalogServiceProtocol
  let cartService: CartServiceProtocol
  let favoritesService: FavoritesServiceProtocol
  let orderService: OrderServiceProtocol
  let cartPersistence: CartPersistenceProtocol

  init() {
    let isUITesting = ProcessInfo.processInfo.arguments.contains("UITESTS")

    if isUITesting {
      self.catalogService = MockCatalogService()
      self.cartService = MockCartService()
      self.favoritesService = MockFavoritesService()
      self.orderService = MockOrderService()
      self.cartPersistence = InMemoryCartPersistence()
    } else {
      TokenBootstrap.run()
      let token = KeychainStore.read(account: TokenBootstrap.account) ?? ""
      self.catalogService = CatalogService(token: token)
      self.cartService = CartService(token: token)
      self.favoritesService = FavoritesService(token: token)
      self.orderService = OrderService(token: token)
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
        cartStore: CartStore(
          cartService: cartService,
          persistence: cartPersistence
        ),
        favoritesStore: FavoritesStore(favoritesService: favoritesService)
      )
    }
  }
}
