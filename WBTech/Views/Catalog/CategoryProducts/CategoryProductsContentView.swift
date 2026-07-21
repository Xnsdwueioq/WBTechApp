//

import SwiftUI
import UISystem

struct CategoryProductsContentView: View {
  let route: CategoryRoute
  let products: [Product]
  let isLoading: Bool
  
  private enum Layout {
    static let productCardFooterStyle = ProductCardFooterStyle.standart
    static let headerListSpacing: CGFloat = 0
    static let topPadding: CGFloat = 10
    static let horizontalPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 12
    static let headerBackground = Color(.systemBackground)
  }
  
  @Environment(CatalogRouter.self) private var router
  
  var body: some View {
    ProductListView(
      products: products,
      productCardFooterStyle: Layout.productCardFooterStyle
    )
    .overlay {
      if isLoading {
        ProgressView()
      }
    }
    .contentMargins(.top, Layout.topPadding, for: .scrollContent)
    .contentMargins(.horizontal, Layout.horizontalPadding, for: .scrollContent)
    .contentMargins(.bottom, Layout.bottomPadding, for: .scrollContent)
    .safeAreaInset(edge: .top, spacing: Layout.headerListSpacing) {
      CategoryProductsHeaderView(
        groupTitle: route.groupTitle,
        categoryTitle: route.categoryTitle,
        onTapBack: { router.pop() }
      )
      .frame(maxWidth: .infinity)
      .background(Layout.headerBackground)
    }
  }
}
