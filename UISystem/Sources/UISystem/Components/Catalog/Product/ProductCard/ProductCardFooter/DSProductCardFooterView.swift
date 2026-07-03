//

import SwiftUI

public enum ProductCardFooterStyle {
  case standart
  case compact
}

public struct DSProductCardFooterView: View {
  let config: DSProductCardConfig
  let footerStyle: ProductCardFooterStyle
  let increaseAction: () -> Void
  let decreaseAction: () -> Void
  
  public init(config: DSProductCardConfig, footerStyle: ProductCardFooterStyle, increaseAction: @escaping () -> Void, decreaseAction: @escaping () -> Void) {
    self.config = config
    self.footerStyle = footerStyle
    self.increaseAction = increaseAction
    self.decreaseAction = decreaseAction
  }
  
  private enum Configuration {
    static let infoAndButtonSpacing: CGFloat = 12
    static let priceAndTitlesSpacing: CGFloat = 4
    static let titleAndRatingSpacing: CGFloat = 0
    static let bottomPadding: CGFloat = 10
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: Configuration.infoAndButtonSpacing) {
      VStack(alignment: .leading, spacing: Configuration.priceAndTitlesSpacing) {
        DSProductCardPrice(price: config.price, priceSign: config.priceSign)
        VStack(alignment: .leading, spacing: Configuration.titleAndRatingSpacing) {
          DSProductCardFooterTitle(title: config.name, weight: config.weight)
          DSProductCardFooterReviews(rating: config.rating, reviewCount: config.reviewCount)
        }
      }
      HStack {
        DSProductCardButton(action: {}, title: "В корзину")
        Spacer()
      }
    }
    .padding(.bottom, Configuration.bottomPadding)
  }
}
