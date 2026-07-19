//

import Foundation
import UISystem

extension Product {
  
  func uiConfig(isFavorite: Bool) -> DSProductConfig {
    DSProductConfig(
      name: self.name,
      weight: "\(Int(self.weight))",
      weightSign: "г",
      price: "\(self.price)",
      priceValue: self.price,
      discount: "\(Int(self.discount))",
      priceSign: "₽",
      imageUrl: self.image,
      rating: self.rating,
      reviewCount: "\(self.reviewCount)",
      reviewCountWord: PluralNoun.review.form(for: self.reviewCount),
      isFavorite: isFavorite
    )
  }
  
  static let uiConfigDefault = DSProductConfig(
    name: "Какой-то товар",
    weight: "500",
    weightSign: "г",
    price: "240",
    priceValue: 240,
    discount: "0",
    priceSign: "₽",
    imageUrl: URL(string: "https://example.com/"),
    rating: 4.6,
    reviewCount: "245",
    reviewCountWord: PluralNoun.review.form(for: 245),
    isFavorite: false
  )
  
}


