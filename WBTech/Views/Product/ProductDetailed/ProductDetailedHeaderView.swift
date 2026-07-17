//
//  ProductDetailedHeaderView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/17/26.
//

import SwiftUI
import UISystem

struct ProductDetailedHeaderView: View {
  let config: DSProductCardConfig
  let onFavoriteTap: () -> Void
  
  private enum Configuration {
    static let contentVerticalSpacing: CGFloat = 0
    static let ratingReviewsTopPadding: CGFloat = 10
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: Configuration.contentVerticalSpacing) {
      HStack {
        Text("\(config.price) \(config.priceSign)")
          .font(Font.dsProductDetailedPrice.bold())
        Spacer()
        DSFavoriteButton(isActive: config.isFavorite, sizeType: .medium, onFavoriteTap: onFavoriteTap)
      }
      DSProductTitle(title: config.name, weight: config.weight, weightSign: config.weightSign, titleStyle: .detailed)
      DSProductRatingReviews(rating: config.rating, reviewCount: config.reviewCount, style: .extended(reviewNoun: "отзывов"), size: .medium)
        .padding(.top, Configuration.ratingReviewsTopPadding)
    }
  }
}
