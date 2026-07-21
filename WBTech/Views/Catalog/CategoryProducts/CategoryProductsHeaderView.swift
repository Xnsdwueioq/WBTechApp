//

import SwiftUI
import UISystem

struct CategoryProductsHeaderView: View {
  let groupTitle: String
  let categoryTitle: String
  let onTapBack: () -> Void
  
  private enum Layout {
    static let topPadding: CGFloat = 10
    static let horizontalPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 8
    static let barTextSpacing: CGFloat = 16
    static let titlesSpacing: CGFloat = 4
    static let alignment: HorizontalAlignment = .leading
  }
  
  var body: some View {
    VStack(alignment: Layout.alignment, spacing: Layout.barTextSpacing) {
      HStack {
        DSBarBackButton(action: onTapBack)
        Spacer()
      }
      VStack(alignment: Layout.alignment, spacing: Layout.titlesSpacing) {
        Text(groupTitle)
          .font(.dsCategoryGroupTitle)
        Text(categoryTitle)
          .font(.dsCategoryTitle)
      }
      .accessibilityElement(children: .combine)
      .accessibilityAddTraits(.isHeader)
    }
    .padding(.top, Layout.topPadding)
    .padding(.horizontal, Layout.horizontalPadding)
    .padding(.bottom, Layout.bottomPadding)
  }
}
