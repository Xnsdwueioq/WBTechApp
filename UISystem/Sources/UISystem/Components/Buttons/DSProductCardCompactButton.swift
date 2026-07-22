//

import SwiftUI

public struct DSProductCardCompactButton: View {
  let price: String
  let priceSign: String
  let onIncrement: () -> Void
  
  public init(price: String, priceSign: String, onIncrement: @escaping () -> Void) {
    self.price = price
    self.priceSign = priceSign
    self.onIncrement = onIncrement
  }
  
  private enum Layout {
    static let elementsSpacing: CGFloat = 4
  }
  
  public var body: some View {
    Button(action: onIncrement) {
      HStack(spacing: Layout.elementsSpacing) {
        Text("\(price)\(priceSign)")
        Image.dsPlusRounded
          .resizable()
          .scaledToFit()
          .frame(width: 12)
          .foregroundStyle(Color.dsSignsAccentColor)
      }
    }
    .buttonStyle(DSButtonStyle(size: .small, style: .productCardVariant))
    .accessibilityLabel("Добавить в корзину")
    .accessibilityValue("\(price)\(priceSign)")
  }
}
