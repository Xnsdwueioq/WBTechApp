//
//  ReviewsView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/22/26.
//

import SwiftUI
import UISystem

struct ReviewsView: View {
  let reviews: [Review]
  let rating: Double
  let onCreateReview: () -> Void
  
  @State private var ratingDist: RatingDistributable

  init(reviews: [Review], rating: Double, onCreateReview: @escaping () -> Void) {
    self.reviews = reviews
    self.rating = rating
    self.onCreateReview = onCreateReview
    self.ratingDist = RatingDistribution(reviews: reviews)
  }
  
  private enum Configuration {
    static let verticalSpacing: CGFloat = 16
    static let horizontalPadding: CGFloat = 12
  }
  
  var body: some View {
    VStack(spacing: Configuration.verticalSpacing) {
      ReviewsTitleView(reviewsCount: reviews.count)
      HStack(spacing: 2) {
        DSRatingComponent(rating: rating, ratingStyle: .onlyNumber, ratingSize: .large)
        RatingGridView(ratingDistribution: ratingDist, rating: rating)
      }
      VStack(alignment: .leading, spacing: 24) {
        Button(action: onCreateReview) {
          HStack {
            Spacer()
            Text("Написать отзыв")
            Spacer()
          }
        }
          .buttonStyle(DSButtonStyle(size: .large, style: .secondary))
        ReviewsList(reviews: reviews)
      }
    }
    .padding(.horizontal, Configuration.horizontalPadding)
  }
}

#Preview {
  ReviewsView(reviews: [
    .init(rating: 5, author: "author1", createdAt: Date(), content: "Some Conte ntdf isdf isd fos", images: [URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUxaV7VjrC33xPiIETJJP2H0SfT6EvAeNfhQ_NcRmfN51KNFJpPC7SZ98&s=10")]),
    .init(rating: 4, author: "author2", createdAt: Date(), content: "Some Sicusdufdyf c,cvobobbpbbp Conte ntdf isdf isd fos", images: []),
    .init(rating: 3, author: "author3", createdAt: Date(), content: "Some Conte ntdf isdf xcpxvvpvppa qkqkkm isd fos", images: [])
  ], rating: 4.01, onCreateReview: {})
}
