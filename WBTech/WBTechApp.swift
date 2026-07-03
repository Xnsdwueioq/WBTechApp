//

import SwiftUI

@main
struct WBTechApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(catalogService: MockCatalogService())
    }
  }
}
