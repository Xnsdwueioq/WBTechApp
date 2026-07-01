//

import Foundation
import UISystem

extension Product {
  
  var uiConfig: DSProductCardConfig {
    DSProductCardConfig(
      name: self.name,
      weight: {
        return "\(Int(self.weight))г"
//        let measurement = Measurement(value: self.weight, unit: UnitMass.grams)
//        return measurement.formatted(.measurement(width: .abbreviated))
      }(),
      price: "\(self.price)",
      priceSign: "₽",
//      price: self.price.formatted(.currency(code: "RUB")),
      imageUrl: self.image,
      rating: self.rating,
      reviewCount: "\(self.reviewCount)",
      reviewCountWord: "отзывов(а)", // TODO: Склонения
      isFavorite: self.isFavorite
    )
  }
  
}
