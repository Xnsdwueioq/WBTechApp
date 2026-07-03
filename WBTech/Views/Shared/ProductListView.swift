//

import SwiftUI
import UISystem

struct ProductListView: View {
  let products: [Product]
  let isLoading: Bool
  let productCardFooterStyle: ProductCardFooterStyle
  
  init(products: [Product], isLoading: Bool, productCardFooterStyle: ProductCardFooterStyle) {
    self.products = products
    self.isLoading = isLoading
    self.productCardFooterStyle = productCardFooterStyle
  }
  
  private enum Layout {
    static let gridVerticalSpacing: CGFloat = 8
    static let columns = Array(
      repeating: GridItem(.flexible(), spacing: 3),
      count: 2
    )
  }
  
  var body: some View {
    ScrollView {
      switch isLoading {
      case true:
        ProgressView()
      case false:
        LazyVGrid(columns: Layout.columns, spacing: Layout.gridVerticalSpacing) {
          ForEach(products) { product in
            DSProductCardView(
              config: product.uiConfig,
              footerStyle: productCardFooterStyle,
              quantity: 0, // TODO: Connect quantity value
              onIncrement: {}, // TODO: Insert actions
              onDecrement: {},
              onFavoriteTap: {},
              onError: nil
            )
          }
        }
      }
    }
    .scrollIndicators(.hidden)
  }
}
