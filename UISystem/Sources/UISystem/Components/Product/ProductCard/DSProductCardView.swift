//

import SwiftUI

public struct DSProductCardView: View {
  let config: DSProductCardConfig
  let footerStyle: ProductCardFooterStyle
  let quantity: Int
  let onTap: () -> Void
  let onIncrement: () -> Void
  let onDecrement: () -> Void
  let onFavoriteTap: () -> Void
  let onError: ((Error) -> Void)?
  
  public init(config: DSProductCardConfig, footerStyle: ProductCardFooterStyle, quantity: Int, onTap: @escaping () -> Void, onIncrement: @escaping () -> Void, onDecrement: @escaping () -> Void, onFavoriteTap: @escaping () -> Void, onError: ((Error) -> Void)? = nil) {
    self.config = config
    self.footerStyle = footerStyle
    self.quantity = quantity
    self.onTap = onTap
    self.onIncrement = onIncrement
    self.onDecrement = onDecrement
    self.onFavoriteTap = onFavoriteTap
    self.onError = onError
  }
  
  private enum Layout {
    static let imageInfoSpacing: CGFloat = 8
    static let favoriteIconPadding: CGFloat = 8
  }
  
  public var body: some View {
    ZStack(alignment: .topTrailing) {
      VStack(spacing: Layout.imageInfoSpacing) {
        DSProductCardImageView(url: config.imageUrl, onError: onError)
        DSProductCardFooterView(
          config: config,
          footerStyle: footerStyle,
          quantity: quantity,
          onIncrement: onIncrement,
          onDecrement: onDecrement
        )
      }
      DSFavoriteButton(
        isActive: config.isFavorite,
        sizeType: .small,
        onFavoriteTap: onFavoriteTap
      )
        .padding(Layout.favoriteIconPadding)
    }
    .onTapGesture(perform: onTap)
  }
}
