//
//  ProductDetailed.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/15/26.
//

import Foundation

struct ProductDetailed: Identifiable, Hashable {
  let id: String
  let image: URL?
  let name: String
  let weight: Double
  let price: Int
  let rating: Double
  let description: String
  let isFavorite: Bool
  let discount: Double
  let reviews: [Review]
}

struct Review: Identifiable, Hashable {
  let rating: Double
  let author: String
  let createdAt: Date
  let content: String
  let images: [URL?]

  var id: String {
    "\(author)-\(createdAt.timeIntervalSince1970)"
  }
}
