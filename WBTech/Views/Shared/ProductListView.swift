//

import SwiftUI
import UISystem

struct ProductListView: View {
  let products: [Product]
  let productCardFooterStyle: ProductCardFooterStyle

  @Environment(FavoritesStore.self) private var favoritesStore
  @Environment(CartStore.self) private var cartStore

  @Environment(ModalRouter.self) private var modalRouter

  init(products: [Product], productCardFooterStyle: ProductCardFooterStyle) {
    self.products = products
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
      LazyVGrid(columns: Layout.columns, spacing: Layout.gridVerticalSpacing) {
        ForEach(products) { product in
          let id = product.id

          DSProductCardView(
            config: product.uiConfig(isFavorite: favoritesStore.isFavorite(id: id, fallback: product.isFavorite)),
            footerStyle: productCardFooterStyle,
            quantity: cartStore.quantity(for: id),
            onTap: { modalRouter.present(route: .productDetailed(product: product)) },
            onIncrement: { Task { await cartStore.increment(id: id) } },
            onDecrement: { Task { await cartStore.remove(id: id) } },
            onFavoriteTap: { Task { await favoritesStore.toggle(id: id, fallback: product.isFavorite) } },
            onError: nil
          )
        }
      }
    }
    .scrollIndicators(.hidden)
  }
}
