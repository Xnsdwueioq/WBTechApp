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
      HStack(spacing: 3) {
        Text("★")
        Text(String(format: "%.1f", rating))
      }
      .font(.dsRatingNumber)
      HStack(spacing: 3) {
        Image.dsReview
        Text(reviewCount)
      }
      .font(.dsProductCardReviewCount)
      Spacer()
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
