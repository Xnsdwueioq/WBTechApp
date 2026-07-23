//
//  ProductDetailedHeaderView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/17/26.
//

import SwiftUI
import UISystem

struct ProductDetailedHeaderView: View {
  let config: DSProductConfig
  let onFavoriteTap: () -> Void
  let onReviews: () -> Void
  
  private enum Configuration {
    static let contentVerticalSpacing: CGFloat = 0
    static let ratingReviewsTopPadding: CGFloat = 10
  }

  private var infoAccessibilityLabel: String {
    [
      config.name,
      "\(config.weight) \(config.weightSign)",
      "\(config.price) \(config.priceSign)",
      "рейтинг \(String(format: "%.1f", config.rating))",
      "\(config.reviewCount) \(config.reviewCountWord)"
    ].joined(separator: ", ")
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Configuration.contentVerticalSpacing) {
      HStack {
        Text("\(config.price) \(config.priceSign)")
          .font(Font.dsProductDetailedPrice.bold())
          .accessibilityHidden(true)
        Spacer()
        DSFavoriteButton(isActive: config.isFavorite, sizeType: .medium, onFavoriteTap: onFavoriteTap)
      }
      VStack(alignment: .leading, spacing: Configuration.contentVerticalSpacing) {
        DSProductTitle(title: config.name, weight: config.weight, weightSign: config.weightSign, titleStyle: .detailed)
        DSProductRatingReviews(rating: config.rating, reviewCount: config.reviewCount, style: .extended(reviewNoun: config.reviewCountWord), size: .medium)
          .padding(.top, Configuration.ratingReviewsTopPadding)
          .onTapGesture(perform: onReviews)
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel(infoAccessibilityLabel)
    }
  }
}
