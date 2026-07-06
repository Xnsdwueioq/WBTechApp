//

import SwiftUI

@main
struct WBTechApp: App {
  let catalogService: CatalogServiceProtocol
  let cartService: CartServiceProtocol = MockCartService()
  let favoritesService: FavoritesServiceProtocol = MockFavoritesService()
  
  init() {
    TokenBootstrap.run()
    let token = KeychainStore.read(account: TokenBootstrap.account) ?? ""
    self.catalogService = CatalogService(token: token)
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
