//

import SwiftUI
import UISystem

struct ProductListView: View {
  let products: [Product]
  let isLoading: Bool
  let onFavoriteTap: () -> Void
  let onAddToCart: () -> Void
  let onError: ((Error) -> Void)?
  
  init(products: [Product], isLoading: Bool, onFavoriteTap: @escaping () -> Void, onAddToCart: @escaping () -> Void, onError: ((Error) -> Void)? = nil) {
    self.products = products
    self.isLoading = isLoading
    self.onFavoriteTap = onFavoriteTap
    self.onAddToCart = onAddToCart
    self.onError = onError
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
              onFavoriteTap: onFavoriteTap,
              onAddToCart: onAddToCart,
              onError: onError
            )
          }
        }
      }
    }
    .scrollIndicators(.hidden)
  }
}
