//

import SwiftUI

public enum DSReviewStyle {
  case compact
  case extended(noun: String)
}

public struct DSReviewComponent: View {
  let reviewCount: String
  let reviewStyle: DSReviewStyle
  
  public init(reviewCount: String, reviewStyle: DSReviewStyle) {
    self.reviewCount = reviewCount
    self.reviewStyle = reviewStyle
  }
  
  private enum Layout {
    static let IconNumberSpacing: CGFloat = 3
  }
  
  public var body: some View {
    HStack(spacing: Layout.IconNumberSpacing) {
      Image.dsReview
      switch reviewStyle {
      case .compact:
        Text(reviewCount)
      case .extended(let noun):
        Text("\(reviewCount) \(noun)")
      }
    }
    .font(.dsReviewsCount)
  }
}

#Preview {
  VStack {
    DSReviewComponent(reviewCount: "2491", reviewStyle: .compact)
    DSReviewComponent(reviewCount: "2491", reviewStyle: .extended(noun: "отзыв"))
  }
}
