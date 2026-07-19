//

import Foundation
import UISystem

extension ProductDetailed {

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
      reviewCount: "\(self.reviews.count)",
      reviewCountWord: PluralNoun.review.form(for: self.reviews.count),
      isFavorite: isFavorite
    )
  }

}
