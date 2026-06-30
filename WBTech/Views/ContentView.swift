//

import SwiftUI

struct ContentView: View {
  let catalogService: CatalogServiceProtocol
  
  @State private var router = CatalogRouter()
  @State private var selectedTab: AppTab = .catalog
  
  private enum Configuration {
    static let selectTabAnimationDuration: CGFloat = 0.25
  }
  
  var body: some View {
    NavigationStack(path: $router.path) {
      Group {
        TabsView(selectedTab: selectedTab, onSelect: selectTab)
        switch selectedTab {
        case .forYou:
          Spacer()
        case .catalog:
          CatalogView(catalogService: catalogService)
        case .discounts:
          Spacer()
        case .favourites:
          Spacer()
        case .alreadyOrdered:
          Spacer()
        }
      }
      .navigationDestination(for: CategoryRoute.self) { route in
        CategoryProductsView(route: route, service: catalogService)
      }
    }
    .environment(router)
  }
  
  private func selectTab(_ tab: AppTab) {
    withAnimation(.easeInOut(duration: Configuration.selectTabAnimationDuration)) {
      selectedTab = tab
    }
  }
}

#Preview {
  ContentView(catalogService: MockCatalogService())
}
