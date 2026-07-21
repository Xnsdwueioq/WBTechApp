//

import SwiftUI

@main
struct WBTechApp: App {
  let catalogService: CatalogServiceProtocol
  let cartService: CartServiceProtocol
  let favoritesService: FavoritesServiceProtocol
  let orderService: OrderServiceProtocol

  init() {
    let isUITesting = ProcessInfo.processInfo.arguments.contains("UITESTS")

    if isUITesting {
      self.catalogService = MockCatalogService()
      self.cartService = MockCartService()
      self.favoritesService = MockFavoritesService()
      self.orderService = MockOrderService()
    } else {
      TokenBootstrap.run()
      let token = KeychainStore.read(account: TokenBootstrap.account) ?? ""
      self.catalogService = CatalogService(token: token)
      self.cartService = CartService(token: token)
      self.favoritesService = FavoritesService(token: token)
      self.orderService = OrderService(token: token)
    }
  }

  var body: some Scene {
    WindowGroup {
      RootTabView(
        catalogService: catalogService,
        orderService: orderService,
        cartStore: CartStore(cartService: cartService),
        favoritesStore: FavoritesStore(favoritesService: favoritesService)
      )
    }
  }
}
