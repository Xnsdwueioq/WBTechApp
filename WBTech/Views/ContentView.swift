//

import SwiftUI

struct ContentView: View {
  let catalogService: CatalogServiceProtocol
  
  @State private var selectedTab: AppTab = .catalog
  
  private enum Configuration {
    static let selectTabAnimationDuration: CGFloat = 0.25
  }
  
  var body: some View {
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
  
  private func selectTab(_ tab: AppTab) {
    withAnimation(.easeInOut(duration: Configuration.selectTabAnimationDuration)) {
      selectedTab = tab
    }
  }
}

#Preview {
  ContentView(catalogService: MockCatalogService())
}
