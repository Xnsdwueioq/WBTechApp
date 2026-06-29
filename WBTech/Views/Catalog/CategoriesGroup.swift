//

import SwiftUI
import UISystem

struct CategoriesGroup: View {
  let title: String
  let categories: [Category]
  
  enum Layout {
    static let titleContentSpacing: CGFloat = 8
  }
  
  var body: some View {
    VStack(spacing: Layout.titleContentSpacing) {
      CategoriesGroupTitle(title: title)
      CategoriesView(categories: categories)
    }
  }
}
