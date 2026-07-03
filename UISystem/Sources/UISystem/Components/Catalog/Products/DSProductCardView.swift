//

import SwiftUI

public struct DSProductCardView: View {
  let config: DSProductCardConfig
  let onFavoriteTap: () -> Void
  let onAddToCart: () -> Void
  let onError: ((Error) -> Void)?
  
  public init(config: DSProductCardConfig, onFavoriteTap: @escaping () -> Void, onAddToCart: @escaping () -> Void, onError: ((Error) -> Void)? = nil) {
    self.config = config
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
      DSProductCardInfoView(config: config)
    }
  }
}

public struct DSProductCardInfoView: View {
  let config: DSProductCardConfig
  
  public init(config: DSProductCardConfig) {
    self.config = config
  }
  
  private enum Configuration {
    static let infoAndButtonSpacing: CGFloat = 12
    static let priceAndTitlesSpacing: CGFloat = 4
    static let titleAndRatingSpacing: CGFloat = 0
    static let bottomPadding: CGFloat = 10
  }
  
  public var body: some View {
    VStack(spacing: Configuration.infoAndButtonSpacing) {
      VStack(spacing: Configuration.priceAndTitlesSpacing) {
        HStack(alignment: .bottom, spacing: 1) {
          Text(config.price)
            .font(.dsProductCardPrice)
          Text(config.priceSign)
            .font(.dsProductCardPriceSign)
          Spacer()
        }
        VStack(spacing: Configuration.titleAndRatingSpacing) {
          HStack(spacing: 8) {
            Text(config.name)
              .font(.dsProductCardTitle)
              .lineLimit(1)
              .truncationMode(.tail)
            Text(config.weight)
              .font(.dsProductCardWeight)
              .foregroundStyle(Color.dsProductWeightColor)
            Spacer()
          }
          HStack {
            HStack(spacing: 3) {
              Text("★")
              Text(String(format: "%.1f", config.rating))
            }
            .font(.dsRatingNumber)
            HStack(spacing: 3) {
              Image.dsReview
              Text(config.reviewCount)
            }
            .font(.dsProductCardReviewCount)
            Spacer()
          }
        }
      }
      
      Button("d3r234") { }
        .buttonBorderShape(.roundedRectangle(radius: 15))
      
    }
    .padding(.bottom, Configuration.bottomPadding)
  }
}

public struct DSProductTitleWithWeightComponent: View {
  public var body: some View {
    
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
  DSProductCardView(config: DSProductCardConfig(name: "Name", weight: "230г", price: "600₽", priceSign: "₽", imageUrl: URL(string: "https://st2.depositphotos.com/1000504/5476/i/450/depositphotos_54765699-stock-photo-sandwich-with-sliced-sausage.jpg"), rating: 4.6, reviewCount: "1234", reviewCountWord: "отзывов", isFavorite: false), onFavoriteTap: {}, onAddToCart: {})
}
