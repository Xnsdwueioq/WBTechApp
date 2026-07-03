//

import SwiftUI

// MARK: Tabs & Catalog & Categories
public extension Font {
  
  static let dsTabTitle = Font.system(size: 16).weight(.medium)
  static let dsCatalogCategoryTitle = Font.system(size: 14).weight(.medium)
  static let dsCatalogGroupTitle = Font.system(size: 32).weight(.medium)
  static let dsCategoryTitle = Font.system(size: 17).weight(.medium)
  static let dsCategoryGroupTitle = Font.system(size: 22).weight(.medium)
  
}

// MARK: Product Card
public extension Font {
  
  static let dsRatingNumber = Font.system(size: 14)
  static let dsProductCardPrice = Font.system(size: 18).weight(.semibold)
  static let dsProductCardPriceSign = Font.system(size: 14).weight(.semibold)
  static let dsProductCardTitle = Font.system(size: 14)
  static let dsProductCardWeight = Font.system(size: 14)
  static let dsProductCardReviewCount = Font.system(size: 14)
  
}

// MARK: Button Style
public extension Font {
  
  static let dsAccent = Font.system(size: 20).weight(.semibold)
  static let dsAccentDisabled = Font.dsAccent
  static let dsStandart = Font.system(size: 16).weight(.medium)
  static let dsProductCardButton = Font.system(size: 14).weight(.semibold)
  static let dsSurface = Font.system(size: 20).weight(.medium)
  static let dsOutline = Font.system(size: 20).weight(.semibold)
  
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
