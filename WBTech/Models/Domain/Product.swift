//

import Foundation

struct Product: Identifiable, Hashable {
  let id: String
  let image: URL?
  let name: String
  let weight: Double
  let price: Int
  let rating: Double
  let reviewCount: Int
  let isFavorite: Bool
  let discount: Double
  
  var formattedPrice: String {
    return price.formatted(.currency(code: "RUB"))
  }
  
  var formattedWeight: String {
    let measurement = Measurement(value: weight, unit: UnitMass.grams)
    return measurement.formatted(.measurement(width: .abbreviated))
  }
}
