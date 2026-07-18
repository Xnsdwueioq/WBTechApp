//

import SwiftUI

public struct DSProductConfig: Equatable, Hashable, Sendable {
  public let name: String
  public let weight: String
  public let weightSign: String
  public let price: String
  public let priceValue: Int
  public let discount: String
  public let priceSign: String
  public let imageUrl: URL?
  public let rating: Double
  public let reviewCount: String
  public let reviewCountWord: String
  public let isFavorite: Bool
  
  public init(name: String, weight: String, weightSign: String, price: String, priceValue: Int, discount: String, priceSign: String, imageUrl: URL?, rating: Double, reviewCount: String, reviewCountWord: String, isFavorite: Bool) {
    self.name = name
    self.weight = weight
    self.weightSign = weightSign
    self.price = price
    self.priceValue = priceValue
    self.discount = discount
    self.priceSign = priceSign
    self.imageUrl = imageUrl
    self.rating = rating
    self.reviewCount = reviewCount
    self.reviewCountWord = reviewCountWord
    self.isFavorite = isFavorite
  }
}
