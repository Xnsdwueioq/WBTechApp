//

import SwiftUI

struct CategoryProductsContentView: View {
  let route: CategoryRoute
  let products: [Product]
  let isLoading: Bool
  
  private enum Layout {
    static let headerListSpacing: CGFloat = 0
    static let topPadding: CGFloat = 10
    static let horizontalPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 12
  }
  
  @Environment(CatalogRouter.self) private var router
  
  var body: some View {
    VStack(spacing: Layout.headerListSpacing) {
      CategoryProductsHeaderView(
        groupTitle: route.groupTitle,
        categoryTitle: route.categoryTitle,
        onTapBack: { router.pop() }
      )
      ProductListView(
        products: products,
        isLoading: isLoading,
        onFavoriteTap: { },
        onAddToCart: { }
      )
      .padding(.top, Layout.topPadding)
      .padding(.horizontal, Layout.horizontalPadding)
      .padding(.bottom, Layout.bottomPadding)
    }
  }
}
