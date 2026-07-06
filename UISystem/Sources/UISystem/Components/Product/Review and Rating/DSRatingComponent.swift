//

import SwiftUI

public enum DSRatingStyle {
  case compact
  case extended
  case onlyStars
  case onlyNumber
}

public struct DSRatingComponent: View {
  let rating: Double
  let ratingStyle: DSRatingStyle
  
  public init(rating: Double, ratingStyle: DSRatingStyle) {
    self.rating = rating
    self.ratingStyle = ratingStyle
  }
  
  private enum Layout {
    static let maxStarsNumber: Int = 5
    static let compactSpacing: CGFloat = 3
    static let extendedSpacing: CGFloat = 3
  }
  
  public var body: some View {
    let ratingNumberText = Text(String(format: "%.1f", rating))
    let extendedStars = DSRatingStarsComponent(starsNumber: Layout.maxStarsNumber, activeStarsNumber: calculateActiveStars())
    
    switch ratingStyle {
    case .compact:
      HStack(spacing: Layout.compactSpacing) {
        DSRatingStarsComponent(starsNumber: 1, activeStarsNumber: 1)
        ratingNumberText
      }
      .font(.dsRatingNumber)
    case .extended:
      HStack(spacing: Layout.extendedSpacing) {
        ratingNumberText
        extendedStars
      }
      .font(.dsRatingNumber)
    case .onlyStars:
      extendedStars
        .font(.dsRatingNumber)
    case .onlyNumber:
      ratingNumberText
        .font(.dsRatingNumber)
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
    DSRatingComponent(rating: 4.5, ratingStyle: .compact)
    DSRatingComponent(rating: 4.5, ratingStyle: .extended)
    DSRatingComponent(rating: 4.5, ratingStyle: .onlyStars)
    DSRatingComponent(rating: 4.5, ratingStyle: .onlyNumber)
  }
}
