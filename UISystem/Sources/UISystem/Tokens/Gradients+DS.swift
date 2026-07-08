//

import SwiftUI

public extension LinearGradient {
  
  static let dsViolet = LinearGradient(
    colors: [
      .dsVioletGradientColor1,
      .dsVioletGradientColor2,
      .dsVioletGradientColor3,
      .dsVioletGradientColor4,
      .dsVioletGradientColor5,
      .dsVioletGradientColor6,
      .dsVioletGradientColor7,
      .dsVioletGradientColor8
    ],
    startPoint: .leading,
    endPoint: .trailing
  )
  
  static let dsFade = LinearGradient(
    stops: [
      .init(color: .dsFadeGradientColor3, location: 0.20),
      .init(color: .dsFadeGradientColor2, location: 0.32),
      .init(color: .dsFadeGradientColor1, location: 0.64)
    ],
    startPoint: .bottom,
    endPoint: .top
  )
  
  static let dsPreviewProgressiveBlurMask = LinearGradient(
    stops: [
      .init(color: .clear, location: 0.6),
      .init(color: .black, location: 0.75)
    ],
    startPoint: .top,
    endPoint: .bottom
  )

  static let dsTabsFade = LinearGradient(
    stops: [
      .init(color: .white, location: 0.01),
      .init(color: .clear, location: 0.05)
    ],
    startPoint: .leading,
    endPoint: .trailing)
  
  static let dsProductCard = LinearGradient(
    colors: [
      .dsProductCardGradientColor1,
      .dsProductCardGradientColor2
    ],
    startPoint: .leading,
    endPoint: .trailing
  )
  
}
