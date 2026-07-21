//

import SwiftUI

// MARK: Tabs & Catalog & Categories
public extension Font {
  
  static let dsPrimaryTitle = Font.system(size: 32).weight(.medium)
  static let dsTabTitle = Font.system(size: 16).weight(.medium)
  static let dsCatalogCategoryTitle = Font.system(size: 14).weight(.medium)
  static let dsCatalogGroupTitle = Self.dsPrimaryTitle
  static let dsCategoryTitle = Font.system(size: 17).weight(.medium)
  static let dsCategoryGroupTitle = Font.system(size: 22).weight(.medium)
  
}

// MARK: Product Detailed View
public extension Font {
  
  static let dsProductDetailedPrice = Font.system(size: 32).weight(.medium)
  static let dsProductDetailedTitle = Font.system(size: 26).weight(.medium)
  static let dsProductDetailedWeight = Font.system(size: 26).weight(.medium)
  
}

// MARK: Cart
public extension Font {

  static let dsCartTitle = Font.system(size: 32).weight(.medium)
  static let dsCartItemsListTitle = Font.system(size: 14).weight(.semibold)
  static let dsCartInfoSecondary = Font.system(size: 14).weight(.regular)
  static let dsCartInfoPrimary = Font.system(size: 17).weight(.semibold)

  static let dsCartCheckoutPrice = Font.system(size: 18).weight(.semibold)
  static let dsCartCheckoutPriceSign = Font.system(size: 14).weight(.semibold)
  static let dsCartCheckoutItems = Font.system(size: 14).weight(.regular)
  static let dsCartCheckoutTitle = Font.system(size: 20).weight(.medium)

}

// MARK: Rating & Review
public extension Font {
  
  static let dsRatingStarCard = Font.system(size: 14)
  static let dsRatingNumberCard = Font.system(size: 14)
  static let dsReviewsCountCard = Font.system(size: 14)
  
  static let dsRatingStarDetailed = Font.system(size: 16)
  static let dsRatingNumberDetailed = Font.system(size: 16)
  static let dsReviewsCountDetailed = Font.system(size: 16)

}

// MARK: Product Card
public extension Font {
  
  static let dsProductCardPrice = Font.system(size: 18).weight(.semibold)
  static let dsProductCardPriceSign = Font.system(size: 14).weight(.semibold)
  static let dsProductCardTitle = Font.system(size: 14)
  static let dsProductCardWeight = Font.system(size: 14)
  
}

// MARK: Button Style
public extension Font {
  
  static let dsLargeStandart = Font.system(size: 20).weight(.semibold)
  static let dsSmallStandart = Font.system(size: 14).weight(.semibold)
  
  static let dsAccent = Font.system(size: 20).weight(.semibold)
  static let dsAccentDisabled = Font.dsAccent
  static let dsStandart = Font.system(size: 16).weight(.medium)
  static let dsProductCardButton = Font.system(size: 14).weight(.semibold)
  static let dsSurface = Font.system(size: 20).weight(.medium)
  static let dsOutline = Font.system(size: 20).weight(.semibold)
  
}

// MARK: Search
public extension Font {
  
  static let dsSearchSuggestion = Font.system(size: 18).weight(.medium)
  
}

#Preview {
  HStack {
    Text("Для тебя")
      .font(Font.dsTabTitle)
      .foregroundStyle(Color.dsTabFontColor)
    Text("Каталог")
      .font(Font.dsTabTitle)
      .foregroundStyle(Color.dsSelectedTabFontColor)
  }
}
