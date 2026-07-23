import SwiftUI

public extension Color {
  
  static let dsDefaultFill = Color(hex: "F6F6FA")
  
  // Tabs
  static let dsTabFontColor = Color(hex: "9797AF")
  static let dsSelectedTabFontColor = Color.primary
  
  // Image
  static let dsImagePlaceholderColor = Color.dsDefaultFill
  static let dsBarBackButton = Color.gray
  
  // Product
  static let dsProductWeightColor = Color.gray
  
  // Rating
  static let dsRatingNumberFontColor = Color.primary
  static let dsRatingActiveStarColor = Color.primary
  static let dsRatingIdleStarColor = Color.gray
  static let dsRatingLine = Color(hex: "F0ECF4")

  // Cart
  static let dsCartCheckoutForeground = Color.white

}

// MARK: - Button Style

public extension Color {
  
  // Foreground
  static let dsAccentButtonForeground = Color.white
  static let dsAccentDisabledButtonForeground = Color.gray
  static let dsStandartButtonForeground = Color.primary
  static let dsProductCardButtonButtonForeground = Color.primary
  static let dsSurfaceButtonForeground = Color.primary
  static let dsOutlineButtonForeground = Color.primary
  
  // Background
  static let dsAccentButtonBackground = Color.white
  static let dsAccentDisabledButtonBackground = Color(hex: "F0ECF4")
  static let dsStandartButtonBackground = Color.dsDefaultFill
  static let dsSurfaceButtonBackground = Color.dsDefaultFill
  static let dsOutlineButtonBackground = Color.clear
  
  // Border
  static let dsSurfaceButtonBorder = Color(hex: "9797AF").opacity(0.3)
  
  // Signs +-
  static let dsSignsAccentColor = Color(hex: "BF22E1")
  
  static let dsSearchSuggestion = Color.primary

}

// MARK: - Gradient Colors

// MARK: Violet
public extension Color {
  
  static let dsVioletGradientColor1 = Color(hex: "ED3CCA")
  static let dsVioletGradientColor2 = Color(hex: "DF34D2")
  static let dsVioletGradientColor3 = Color(hex: "D02BD9")
  static let dsVioletGradientColor4 = Color(hex: "BF22E1")
  static let dsVioletGradientColor5 = Color(hex: "AE1AE8")
  static let dsVioletGradientColor6 = Color(hex: "9A10F0")
  static let dsVioletGradientColor7 = Color(hex: "8306F7")
  static let dsVioletGradientColor8 = Color(hex: "6600FF")
  
}

// MARK: Fade
public extension Color {
  
  static let dsFadeGradientColor1 = Color.dsDefaultFill
  static let dsFadeGradientColor2 = Color(hex: "F9F9FC").opacity(0.36)
  static let dsFadeGradientColor3 = Color.clear
  
}

// MARK: ProductCard
public extension Color {
  
  static let dsProductCardGradientColor1 = Color(hex: "FFF0FB")
  static let dsProductCardGradientColor2 = Color(hex: "F3ECFE")
  
}
