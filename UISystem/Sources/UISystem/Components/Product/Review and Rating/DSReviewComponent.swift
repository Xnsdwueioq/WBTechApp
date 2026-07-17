//

import SwiftUI

public enum DSReviewStyle {
  case compact
  case extended(noun: String)
}

public enum DSReviewSize {
  case small
  case medium
  
  var font: Font {
    switch self {
    case .small: return .dsReviewsCountCard
    case .medium: return .dsReviewsCountDetailed
    }
  }
}

public struct DSReviewComponent: View {
  let reviewCount: String
  let reviewStyle: DSReviewStyle
  let reviewSize: DSReviewSize
  
  public init(reviewCount: String, reviewStyle: DSReviewStyle, reviewSize: DSReviewSize) {
    self.reviewCount = reviewCount
    self.reviewStyle = reviewStyle
    self.reviewSize = reviewSize
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
    .font(reviewSize.font)
  }
}

#Preview {
  VStack {
    DSReviewComponent(reviewCount: "2491", reviewStyle: .compact, reviewSize: .small)
    DSReviewComponent(reviewCount: "2491", reviewStyle: .extended(noun: "отзыв"), reviewSize: .small)
  }
}
