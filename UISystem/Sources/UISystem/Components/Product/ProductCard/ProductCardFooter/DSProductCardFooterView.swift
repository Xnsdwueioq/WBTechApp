//

import SwiftUI

public enum ProductCardFooterStyle: Sendable {
  case standart
  case compact
}

public struct DSProductCardFooterView: View {
  let config: DSProductConfig
  let footerStyle: ProductCardFooterStyle
  let quantity: Int
  let onIncrement: () -> Void
  let onDecrement: () -> Void
  
  public init(config: DSProductConfig, footerStyle: ProductCardFooterStyle, quantity: Int, onIncrement: @escaping () -> Void, onDecrement: @escaping () -> Void) {
    self.config = config
    self.footerStyle = footerStyle
    self.quantity = quantity
    self.onIncrement = onIncrement
    self.onDecrement = onDecrement
  }
  
  private enum Configuration {
    static let infoAndButtonSpacing: CGFloat = 12
    static let priceAndTitlesSpacing: CGFloat = 4
    static let titleAndRatingSpacing: CGFloat = 0
    static let bottomPadding: CGFloat = 10
  }

  private var infoAccessibilityLabel: String {
    var parts: [String] = [
      config.name,
      "\(config.weight) \(config.weightSign)"
    ]
    if footerStyle == .standart {
      parts.append("\(config.price) \(config.priceSign)")
    }
    parts.append("рейтинг \(String(format: "%.1f", config.rating))")
    parts.append("\(config.reviewCount) \(config.reviewCountWord)")
    return parts.joined(separator: ", ")
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: Configuration.infoAndButtonSpacing) {
      VStack(alignment: .leading, spacing: Configuration.priceAndTitlesSpacing) {
        switch footerStyle {
        case .standart:
          DSProductCardPrice(
            price: config.price,
            priceSign: config.priceSign
          )
        case .compact:
          EmptyView()
        }
        VStack(alignment: .leading, spacing: Configuration.titleAndRatingSpacing) {
          DSProductTitle(
            title: config.name,
            weight: config.weight,
            weightSign: config.weightSign
          )
          DSProductRatingReviews(
            rating: config.rating,
            reviewCount: config.reviewCount,
            style: .compact,
            size: .small
          )
        }
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel(infoAccessibilityLabel)
      HStack {
        DSProductCardButton(
          quantity: quantity,
          price: config.price,
          priceValue: config.priceValue,
          priceSign: config.priceSign,
          footerStyle: footerStyle,
          onIncrement: onIncrement,
          onDecrement: onDecrement
        )
        Spacer()
      }
    }
    .padding(.bottom, Configuration.bottomPadding)
  }
}
