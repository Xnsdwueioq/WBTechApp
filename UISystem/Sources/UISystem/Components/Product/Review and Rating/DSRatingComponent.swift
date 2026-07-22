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
  
  var ratingNumberFont: Font {
    switch self {
    case .small: return .dsRatingNumberCard
    case .medium: return .dsRatingNumberDetailed
    }
  }
  
  var ratingStarFont: Font {
    switch self {
    case .small: return .dsRatingStarCard
    case .medium: return .dsRatingStarDetailed
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
    let extendedStars = DSRatingStarsComponent(starsNumber: Layout.maxStarsNumber, activeStarsNumber: calculateActiveStars(), starFont: ratingSize.ratingStarFont)
    
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
  
  private func calculateActiveStars() -> Int {
    switch rating {
    case 4...4.5: return 4
    case 4.5...: return 5
    case 3..<4: return 3
    case 2..<3: return 2
    default: return 1
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
