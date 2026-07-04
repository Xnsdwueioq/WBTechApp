//

import SwiftUI

public struct DSProductCardConfig {
  public let name: String
  public let weight: String
  public let price: String
  public let priceSign: String
  public let imageUrl: URL?
  public let rating: Double
  public let reviewCount: String
  public let reviewCountWord: String
  public let isFavorite: Bool
  
  public init(name: String, weight: String, price: String, priceSign: String, imageUrl: URL?, rating: Double, reviewCount: String, reviewCountWord: String, isFavorite: Bool) {
    self.name = name
    self.weight = weight
    self.price = price
    self.priceSign = priceSign
    self.imageUrl = imageUrl
    self.rating = rating
    self.reviewCount = reviewCount
    self.reviewCountWord = reviewCountWord
    self.isFavorite = isFavorite
  }
}
