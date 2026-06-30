//

import SwiftUI
import UISystem

struct CategoriesView: View {
  let groupTitle: String
  let categories: [Category]
  
  @Environment(CatalogRouter.self) private var router
  
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
        DSCategoryView(
          title: category.name,
          url: category.image,
          action: {
            router.pushCategory(
              id: category.id,
              title: category.name,
              groupTitle: groupTitle
            )
          }
        )
      }
    }
  }
}
