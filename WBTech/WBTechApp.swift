//

import SwiftUI

@main
struct WBTechApp: App {
  let catalogService: CatalogServiceProtocol
  let cartService: CartServiceProtocol
  let favoritesService: FavoritesServiceProtocol
  
  init() {
    TokenBootstrap.run()
    let token = KeychainStore.read(account: TokenBootstrap.account) ?? ""
    self.catalogService = CatalogService(token: token)
    self.cartService = CartService(token: token)
    self.favoritesService = FavoritesService(token: token)
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView(
        catalogService: catalogService,
        cartStore: CartStore(cartService: cartService),
        favoritesStore: FavoritesStore(favoritesService: favoritesService)
      )
    }
  }
}
