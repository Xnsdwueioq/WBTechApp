//

import SwiftUI
import UISystem

struct TabsView: View {
  var selectedTab: AppTab
  let onSelect: (AppTab) -> Void
  
  private enum Layout {
    static let tabsSpacing: CGFloat = 16
    static let horizontalSpacing: CGFloat = 12
    static let tabsFade: LinearGradient = .dsTabsFade
  }
  
  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: Layout.tabsSpacing) {
        ForEach(AppTab.allCases) { tab in
          DSTabButton(
            title: tab.rawValue,
            isSelected: tab == selectedTab,
            action: { onSelect(tab) }
          )
        }
      }
      .padding(.horizontal, Layout.horizontalSpacing)
    }
    .scrollIndicators(.hidden)
      .overlay {
        Layout.tabsFade
      }
  }
}
