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
      DSCategoriesGroupTitle(title: title)
      CategoriesView(groupTitle: title, categories: categories)
    }
  }
}
