//

import SwiftUI

public struct DSProductDetailedButton: View {
  let quantity: Int
  let priceValue: Int
  let priceSign: String
  let onIncrement: () -> Void
  let onDecrement: () -> Void

  public init(quantity: Int, priceValue: Int, priceSign: String, onIncrement: @escaping () -> Void, onDecrement: @escaping () -> Void) {
    self.quantity = quantity
    self.priceValue = priceValue
    self.priceSign = priceSign
    self.onIncrement = onIncrement
    self.onDecrement = onDecrement
  }

  private enum Configuration {
    static let buttonTitle = "В корзину"
  }

  public var body: some View {
    switch quantity {
    case 1...:
      DSProductStepper(
        quantity: quantity,
        priceValue: priceValue,
        priceSign: priceSign,
        size: .large,
        onIncrement: onIncrement,
        onDecrement: onDecrement
      )
    default:
      Button(action: onIncrement) {
        Text(Configuration.buttonTitle)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(DSButtonStyle(size: .large, style: .accent))
    }
  }
}

#Preview {
  @Previewable @State var quantity = 0
  VStack(spacing: 16) {
    DSProductDetailedButton(quantity: quantity, priceValue: 900, priceSign: "₽", onIncrement: { quantity += 1 }, onDecrement: { quantity -= 1 })
  }
  .padding()
}
