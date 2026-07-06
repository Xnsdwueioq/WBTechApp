//

import SwiftUI

public enum DSProductRatingReviewsStyle: Sendable {
  case compact
  case extended(reviewNoun: String)
}

public struct DSProductRatingReviews: View {
  let rating: Double
  let reviewCount: String
  let style: DSProductRatingReviewsStyle
  
  public init(rating: Double, reviewCount: String, style: DSProductRatingReviewsStyle) {
    self.rating = rating
    self.reviewCount = reviewCount
    self.style = style
  }
  
  public var body: some View {
    let style: (ratingStyle: DSRatingStyle, reviewStyle: DSReviewStyle) = {
      switch style {
      case .compact: return (DSRatingStyle.compact, DSReviewStyle.compact)
      case .extended(let reviewNoun): return (DSRatingStyle.extended, DSReviewStyle.extended(noun: reviewNoun))
      }
    }()
    
    HStack {
      DSRatingComponent(rating: rating, ratingStyle: style.ratingStyle)
      DSReviewComponent(reviewCount: reviewCount, reviewStyle: style.reviewStyle)
      Spacer()
    }
  }
}
