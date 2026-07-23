//
//  RatingDistribution.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/22/26.
//

import SwiftUI
import UISystem

protocol RatingDistributable {

  var counts: [Int: Int] { get }
  var total: Int { get }
  subscript(stars: Int) -> Int { get }
  
}

struct RatingDistribution: RatingDistributable {
  private(set) var counts: [Int: Int]
  
  init(reviews: [Review]) {
    self.counts = Dictionary(
      grouping: reviews,
      by: { DSRatingConfig.getIntegerRating(from: $0.rating) }
    )
      .mapValues { $0.count }
  }
  
  subscript(stars: Int) -> Int {
    counts[stars, default: 0]
  }
  
  var total: Int {
    counts.values.reduce(0, +)
  }

}
