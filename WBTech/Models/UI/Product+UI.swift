//

import Foundation
import UISystem

extension Product {
  
  func uiConfig(isFavorite: Bool) -> DSProductCardConfig {
    DSProductCardConfig(
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
      reviewCountWord: "отзывов(а)", // TODO: Склонения
      isFavorite: isFavorite
    )
  }
  
}
