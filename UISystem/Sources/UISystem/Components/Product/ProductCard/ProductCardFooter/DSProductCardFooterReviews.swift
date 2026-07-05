//

import SwiftUI

public struct DSProductCardFooterReviews: View {
  let rating: Double
  let reviewCount: String
  
  public init(rating: Double, reviewCount: String) {
    self.rating = rating
    self.reviewCount = reviewCount
  }
  
  public var body: some View {
    HStack {
      DSRatingComponent(rating: rating, ratingStyle: .compact)
      HStack(spacing: 3) {
        Image.dsReview
        Text(reviewCount)
      }
      .font(.dsProductCardReviewCount)
      Spacer()
    }
  }
}
