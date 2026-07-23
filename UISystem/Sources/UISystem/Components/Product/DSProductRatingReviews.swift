//

import SwiftUI

public enum DSProductRatingReviewsStyle: Sendable {
  case compact
  case extended(reviewNoun: String)
}

public enum DSRatingReviewsSize: Sendable {
  case small
  case medium
  
  var ratingSize: DSRatingSize {
    switch self {
    case .small: return .small
    case .medium: return .medium
    }
  }
  
  var reviewSize: DSReviewSize {
    switch self {
    case .small: return .small
    case .medium: return .medium
    }
  }
}

public struct DSProductRatingReviews: View {
  let rating: Double
  let reviewCount: String
  let style: DSProductRatingReviewsStyle
  let size: DSRatingReviewsSize
  
  public init(rating: Double, reviewCount: String, style: DSProductRatingReviewsStyle, size: DSRatingReviewsSize) {
    self.rating = rating
    self.reviewCount = reviewCount
    self.style = style
    self.size = size
  }
  
  private enum Configuration {
    static let componentsSpacing: CGFloat = 10
  }
  
  public var body: some View {
    let style: (ratingStyle: DSRatingStyle, reviewStyle: DSReviewStyle) = {
      switch style {
      case .compact: return (DSRatingStyle.compact, DSReviewStyle.compact)
      case .extended(let reviewNoun): return (DSRatingStyle.extended, DSReviewStyle.extended(noun: reviewNoun))
      }
    }()
    
    HStack(spacing: Configuration.componentsSpacing) {
      DSRatingComponent(rating: rating, ratingStyle: style.ratingStyle, ratingSize: size.ratingSize)
      DSReviewComponent(reviewCount: reviewCount, reviewStyle: style.reviewStyle, reviewSize: size.reviewSize)
      if case .extended = style.reviewStyle {
        Image.dsReviewChevron
      }
    }
  }
}
