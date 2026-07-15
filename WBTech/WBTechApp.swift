//

import SwiftUI

@main
struct WBTechApp: App {
  let catalogService: CatalogServiceProtocol
  let cartService: CartServiceProtocol
  let favoritesService: FavoritesServiceProtocol
  
  init() {
    let isUITesting = ProcessInfo.processInfo.arguments.contains("UITESTS")
    
    if isUITesting {
      self.catalogService = MockCatalogService()
      self.cartService = MockCartService()
      self.favoritesService = MockFavoritesService()
    } else {
      TokenBootstrap.run()
      let token = KeychainStore.read(account: TokenBootstrap.account) ?? ""
      self.catalogService = CatalogService(token: token)
      self.cartService = CartService(token: token)
      self.favoritesService = FavoritesService(token: token)
    }
  }
  
  var body: some Scene {
    WindowGroup {
      RootTabView(
        catalogService: catalogService,
        cartStore: CartStore(cartService: cartService),
        favoritesStore: FavoritesStore(favoritesService: favoritesService)
      )
    }
  }
}
