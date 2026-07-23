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
  let productId: String
  let config: DSProductConfig
  let description: String?
  let catalogService: CatalogServiceProtocol
  let onReviewCreated: () -> Void

  @State private var isCreatingReview = false

  private var ratingDist: RatingDistributable {
    RatingDistribution(reviews: reviews)
  }
  
  private enum Configuration {
    static let titleTopPadding: CGFloat = 15
    static let verticalSpacing: CGFloat = 16
    static let horizontalPadding: CGFloat = 12
    static let contentSpacing: CGFloat = 24
    static let headerSpacing: CGFloat = 2
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: Configuration.verticalSpacing) {
        Group {
          ReviewsTitleView(reviewsCount: reviews.count)
            .padding(.top, Configuration.titleTopPadding)
          HStack(spacing: Configuration.headerSpacing) {
            DSRatingComponent(rating: rating, ratingStyle: .onlyNumber, ratingSize: .large)
            RatingGridView(ratingDistribution: ratingDist, rating: rating)
          }
        }
        .padding(.horizontal, Configuration.horizontalPadding)
        VStack(alignment: .leading, spacing: Configuration.contentSpacing) {
          Button(action: { isCreatingReview.toggle() }) {
            HStack {
              Spacer()
              Text("Написать отзыв")
              Spacer()
            }
          }
          .padding(.horizontal, Configuration.horizontalPadding)
          .buttonStyle(DSButtonStyle(size: .large, style: .secondary))
          ReviewsList(reviews: reviews)
        }
      }
    }
    .sheet(isPresented: $isCreatingReview) {
      ReviewCreatingView(
        config: config,
        description: description,
        productId: productId,
        catalogService: catalogService,
        onReviewCreated: onReviewCreated
      )
    }
  }
}

#Preview {
  ReviewsView(reviews: [
    .init(rating: 5, author: "author1", createdAt: Date(), content: "Some Conte ntdf isdf isd fos", images: [URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUxaV7VjrC33xPiIETJJP2H0SfT6EvAeNfhQ_NcRmfN51KNFJpPC7SZ98&s=10")]),
    .init(rating: 4, author: "author2", createdAt: Date(), content: "Some Sicusdufdyf c,cvobobbpbbp Conte ntdf isdf isd fos", images: []),
    .init(rating: 3, author: "author3", createdAt: Date(), content: "Some Conte ntdf isdf xcpxvvpvppa qkqkkm isd fos", images: []),
    .init(rating: 3, author: "author34", createdAt: Date(), content: "Some Conte ntdf isdf xcpxvvpvppa qkqkkm isd fos", images: []),
    .init(rating: 3, author: "author53", createdAt: Date(), content: "Some Conte ntdf isdf xcpxvvpvppa qkqkkm isd fos", images: [])
  ], rating: 4.49, productId: "123132", config: DSProductConfig(
    name: "Бутер с колбасой",
    weight: "100",
    weightSign: " г",
    price: "100",
    priceValue: 100,
    discount: "0",
    priceSign: "₽",
    imageUrl: nil,
    rating: 4.49,
    reviewCount: "5",
    reviewCountWord: "отзывов",
    isFavorite: false
  ), description: "Белый хлеб: мука пшеничная высшего сорта, вода очищенная.", catalogService: MockCatalogService(), onReviewCreated: {})
}
