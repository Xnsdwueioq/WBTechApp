//

import SwiftUI

@main
struct WBTechApp: App {
  let catalogService: CatalogServiceProtocol = MockCatalogService()
  let cartService: CartServiceProtocol = MockCartService()
  let favoritesService: FavoritesServiceProtocol = MockFavoritesService()
  
  init() {
    TokenBootstrap.run()
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
