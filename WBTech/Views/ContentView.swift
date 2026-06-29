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
    CatalogView(catalogService: catalogService)
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
