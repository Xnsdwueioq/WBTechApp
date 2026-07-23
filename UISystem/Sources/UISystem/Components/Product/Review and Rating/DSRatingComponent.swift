//

import SwiftUI

public enum DSRatingStyle {
  case compact
  case extended
  case onlyStars
  case onlyNumber
}

public enum DSRatingSize {
  case small
  case medium
  case large
  
  var ratingNumberFont: Font {
    switch self {
    case .small: return .dsRatingNumberCard
    case .medium: return .dsRatingNumberDetailed
    case .large: return .dsAverageRatingDetailedReview
    }
  }
  
  var ratingStarFont: Font {
    switch self {
    case .small: return .dsRatingStarCard
    case .medium: return .dsRatingStarDetailed
    case .large: return .dsAverageRatingDetailedReview
    }
  }
}

public struct DSRatingComponent: View {
  let rating: Double
  let ratingStyle: DSRatingStyle
  let ratingSize:DSRatingSize
  
  public init(rating: Double, ratingStyle: DSRatingStyle, ratingSize: DSRatingSize) {
    self.rating = rating
    self.ratingStyle = ratingStyle
    self.ratingSize = ratingSize
  }
  
  private enum Layout {
    static let maxStarsNumber: Int = 5
    static let compactSpacing: CGFloat = 3
    static let extendedSpacing: CGFloat = 3
  }
  
  public var body: some View {
    let ratingNumberText = Text(String(format: "%.1f", rating))
    let extendedStars = DSRatingStarsComponent(starsNumber: Layout.maxStarsNumber, activeStarsNumber: DSRatingConfig.getIntegerRating(from: rating), starFont: ratingSize.ratingStarFont)
    
    switch ratingStyle {
    case .compact:
      HStack(spacing: Layout.compactSpacing) {
        DSRatingStarsComponent(starsNumber: 1, activeStarsNumber: 1, starFont: ratingSize.ratingStarFont)
        ratingNumberText
      }
      .font(ratingSize.ratingNumberFont)
    case .extended:
      HStack(spacing: Layout.extendedSpacing) {
        ratingNumberText
        extendedStars
      }
      .font(ratingSize.ratingNumberFont)
    case .onlyStars:
      extendedStars
        .font(ratingSize.ratingNumberFont)
    case .onlyNumber:
      ratingNumberText
        .font(ratingSize.ratingNumberFont)
    }
  }
}

#Preview {
  VStack {
    DSRatingComponent(rating: 4.5, ratingStyle: .compact, ratingSize: .medium)
    DSRatingComponent(rating: 4.5, ratingStyle: .extended, ratingSize: .medium)
    DSRatingComponent(rating: 4.5, ratingStyle: .onlyStars, ratingSize: .medium)
    DSRatingComponent(rating: 4.5, ratingStyle: .onlyNumber, ratingSize: .medium)
  }
}
