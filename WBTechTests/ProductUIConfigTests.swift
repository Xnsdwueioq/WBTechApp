//

import Testing
import Foundation
import UISystem
@testable import WBTech

struct ProductUIConfigTests {
  
  @Test func productUIConfig() {
    let product = Product(
      id: "someID",
      image: URL(string: "https://google.com/someImage.png"),
      name: "someName",
      weight: 400.0,
      price: 1200,
      rating: 4.56,
      reviewCount: 124,
      isFavorite: false,
      discount: 50
    )
  
    let config = product.uiConfig(isFavorite: true)

    #expect(config.name == "someName")
    #expect(config.weight == "400")
    #expect(config.weightSign == "г")
    #expect(config.price == "1200")
    #expect(config.priceValue == 1200)
    #expect(config.discount == "50")
    #expect(config.priceSign == "₽")
    #expect(config.rating == 4.56)
    #expect(config.reviewCount == "124")
    #expect(config.reviewCountWord == "отзывов(а)")
    #expect(config.isFavorite == true)
  }
  
}
