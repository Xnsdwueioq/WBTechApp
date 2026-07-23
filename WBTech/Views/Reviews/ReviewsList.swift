//
//  ReviewsList.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/23/26.
//

import SwiftUI
import UISystem

struct ReviewsList: View {
  let reviews: [Review]
  
  private enum Configuration {
    static let reviewsSpacing: CGFloat = 2
  }
  
  var body: some View {
    VStack(spacing: Configuration.reviewsSpacing) {
      ForEach(reviews) { review in
        DSDetailedReview(
          author: review.author,
          createdAt: review.createdAt,
          rating: review.rating,
          content: review.content,
          images: review.images
        )
      }
    }
  }
}
