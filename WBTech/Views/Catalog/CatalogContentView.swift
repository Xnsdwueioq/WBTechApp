//

import SwiftUI

struct CatalogContentView: View {
  let categories: [Category]
  
  private enum Layout {
    static let topPadding: CGFloat = 20
    static let horizontalPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 0
  }
  
  var body: some View {
    VStack {
      CategoriesGroup(title: "От Даркстора", categories: categories)
    }
    .padding(.top, Layout.topPadding)
    .padding(.horizontal, Layout.horizontalPadding)
    .padding(.bottom, Layout.bottomPadding)
  }
}
