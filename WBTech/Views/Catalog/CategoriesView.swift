//

import SwiftUI
import UISystem

struct CategoriesView: View {
  let categories: [Category]
  
  private enum Layout {
    static let gridVerticalSpacing: CGFloat = 3
    static let columns = Array(
      repeating: GridItem(.flexible(), spacing: 3),
      count: 3
    )
  }
  
  var body: some View {
    LazyVGrid(columns: Layout.columns, spacing: Layout.gridVerticalSpacing) {
      ForEach(categories, id: \.id) { category in
        CategoryView(title: category.name, url: category.image, action: { print("Button has been clicked") })
      }
    }
  }
}
