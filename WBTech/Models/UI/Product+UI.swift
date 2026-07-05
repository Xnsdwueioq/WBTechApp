//

import Foundation
import UISystem

extension Product {
  
  var uiConfig: DSProductCardConfig {
    DSProductCardConfig(
      name: self.name,
      weight: "\(Int(self.weight))",
      weightSign: "г",
      price: "\(self.price)",
      discount: "\(self.discount)",
      priceSign: "₽",
      imageUrl: self.image,
      rating: self.rating,
      reviewCount: "\(self.reviewCount)",
      reviewCountWord: "отзывов(а)", // TODO: Склонения
      isFavorite: self.isFavorite
    )
  }
  
}
