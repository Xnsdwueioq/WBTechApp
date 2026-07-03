//

import SwiftUI

public struct DSProductCardView: View {
  let config: DSProductCardConfig
  let footerStyle: ProductCardFooterStyle
  let onFavoriteTap: () -> Void
  let onAddToCart: () -> Void
  let onError: ((Error) -> Void)?
  
  public init(config: DSProductCardConfig, footerStyle: ProductCardFooterStyle, onFavoriteTap: @escaping () -> Void, onAddToCart: @escaping () -> Void, onError: ((Error) -> Void)? = nil) {
    self.config = config
    self.footerStyle = footerStyle
    self.onFavoriteTap = onFavoriteTap
    self.onAddToCart = onAddToCart
    self.onError = onError
  }
  
  private enum Layout {
    static let imageInfoSpacing: CGFloat = 8
  }
  
  public var body: some View {
    VStack(spacing: Layout.imageInfoSpacing) {
      DSProductCardImageView(url: config.imageUrl, onError: onError)
      DSProductCardFooterView(config: config, footerStyle: footerStyle, increaseAction: {}, decreaseAction: {})
    }
  }
}

//public struct DSRatingView: View {
//  public enum Style {
//    /// Одна звезда и цифра (★ 4.8)
//    case compact
//    /// Пять звезд и цифра (4.8 ★★★★★)
//    case detailed
//    /// Только пять звезд (★★★★★)
//    case onlyStars
//  }
//
//  private let rating: Double
//  private let style: Style
//
//  public init(rating: Double, style: Style) {
//    self.rating = rating
//    self.style = style
//  }
//
//  private enum Configuration {
//    static let starSize: CGFloat = 12
//  }
//
//  private var activeStars: Int {
//    Int(rating.rounded())
//  }
//
//  private var formattedRating: String {
//    String(format: "%.1f", rating)
//  }
//
//  public var body: some View {
//    switch style {
//    case .compact:
//      HStack(spacing: 4) {
//        Image(systemName: "star.fill")
//          .foregroundStyle(Color.dsRatingFillStarColor)
//          .frame(width: 12)
//        Text(formattedRating)
//          .font(Font.dsProductCardRating)
//      }
//    case .detailed:
//      <#code#>
//    case .onlyStars:
//      <#code#>
//    }
//  }
//}


#Preview {
  DSProductCardView(config: DSProductCardConfig(name: "Name", weight: "230г", price: "600", priceSign: "₽", imageUrl: URL(string: "https://st2.depositphotos.com/1000504/5476/i/450/depositphotos_54765699-stock-photo-sandwich-with-sliced-sausage.jpg"), rating: 4.6, reviewCount: "1234", reviewCountWord: "отзывов", isFavorite: false), footerStyle: .standart, onFavoriteTap: {}, onAddToCart: {})
}
