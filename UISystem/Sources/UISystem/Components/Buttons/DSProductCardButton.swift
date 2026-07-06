//

import SwiftUI

public struct DSProductCardButton: View {
  let quantity: Int
  let price: String
  let priceValue: Int
  let priceSign: String
  let footerStyle: ProductCardFooterStyle
  let onIncrement: () -> Void
  let onDecrement: () -> Void
  
  public init(quantity: Int, price: String, priceValue: Int, priceSign: String, footerStyle: ProductCardFooterStyle, onIncrement: @escaping () -> Void, onDecrement: @escaping () -> Void) {
    self.quantity = quantity
    self.price = price
    self.priceValue = priceValue
    self.priceSign = priceSign
    self.footerStyle = footerStyle
    self.onIncrement = onIncrement
    self.onDecrement = onDecrement
  }
  
  private enum Configuration {
    static let buttonTitle = "В корзину"
  }
  
  public var body: some View {
    switch (quantity, footerStyle) {
    case (0, ProductCardFooterStyle.standart):
      Button(Configuration.buttonTitle, action: onIncrement)
        .buttonStyle(DSButtonStyle(size: .small, style: .productCardVariant))
    case (0, ProductCardFooterStyle.compact):
      DSProductCardCompactButton(price: price, priceSign: priceSign, onIncrement: onIncrement)
    case (1..., _):
      DSProductCardStepper(quantity: quantity, priceValue: priceValue, priceSign: priceSign, onIncrement: onIncrement, onDecrement: onDecrement)
    default: EmptyView()
    }
  }
}


#Preview {
  DSProductCardButton(quantity: 0, price: "1200", priceValue: 1200, priceSign: "$", footerStyle: .compact, onIncrement: {}, onDecrement: {})
  DSProductCardButton(quantity: 0, price: "1200", priceValue: 1200, priceSign: "$", footerStyle: .standart, onIncrement: {}, onDecrement: {})
  DSProductCardButton(quantity: 2, price: "1200", priceValue: 1200, priceSign: "$", footerStyle: .compact, onIncrement: {}, onDecrement: {})
  DSProductCardButton(quantity: 2, price: "1200", priceValue: 1200, priceSign: "$", footerStyle: .standart, onIncrement: {}, onDecrement: {})
}
