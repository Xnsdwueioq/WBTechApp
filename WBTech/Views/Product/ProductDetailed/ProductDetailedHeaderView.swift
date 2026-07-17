//
//  ProductDetailedHeaderView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/17/26.
//

import SwiftUI
import UISystem

struct ProductDetailedHeaderView: View {
  let product: DSProductCardConfig
  let isFavorite: Bool
  let onFavoriteTap: () -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 10) {
        Text("\(product.price) \(product.priceSign)")
          .font(Font.dsProductDetailedPrice.bold())
        Spacer()
        DSFavoriteButton(isActive: isFavorite, sizeType: .medium, onFavoriteTap: onFavoriteTap)
      }
      DSProductTitle(title: product.name, weight: product.weight, weightSign: product.weightSign, titleStyle: .detailed)
      DSProductRatingReviews(rating: product.rating, reviewCount: product.reviewCount, style: .extended(reviewNoun: "отзывов"), size: .medium)
        .padding(.top, 10)
    }
  }
}
