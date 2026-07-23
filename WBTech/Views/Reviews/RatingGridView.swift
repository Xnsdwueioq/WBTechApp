//
//  RatingGridView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/22/26.
//

import SwiftUI
import UISystem

struct RatingGridView: View {
  let ratingDistribution: RatingDistributable
  let rating: Double
  
  private enum Configuration {
    static let horizontalSpacing: CGFloat = 8
    static let verticalSpacing: CGFloat = 4
    
    static let starsAlignment: HorizontalAlignment = .trailing
    static let reviewCountsAlignment: HorizontalAlignment = .leading
  }
  
  var body: some View {
    Grid(
      alignment: .center,
      horizontalSpacing: Configuration.horizontalSpacing,
      verticalSpacing: Configuration.verticalSpacing
    ) {
      ForEach((1...5).reversed(), id: \.self) { grade in
        let gradeReviews = ratingDistribution[grade]
        let total = ratingDistribution.total
        
        GridRow(alignment: .center) {
          DSRatingStarsComponent(
            starsNumber: grade,
            activeStarsNumber: gradeReviews != 0 ? grade : 0,
            starFont: .dsRatingStarCard
          )
          .gridColumnAlignment(Configuration.starsAlignment)
          
          DSRatingProgressBar(
            current: gradeReviews,
            total: total
          )
          
          Text(String(gradeReviews))
            .font(.dsRatingNumberCard)
            .gridColumnAlignment(Configuration.reviewCountsAlignment)
        }
      }
    }
  }
}
