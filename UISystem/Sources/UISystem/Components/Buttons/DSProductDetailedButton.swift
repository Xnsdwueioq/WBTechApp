//

import SwiftUI

public struct DSProductDetailedButton: View {
  let quantity: Int
  let priceValue: Int
  let priceSign: String
  let onIncrement: () -> Void
  let onDecrement: () -> Void
  let onOpenCart: () -> Void

  public init(quantity: Int, priceValue: Int, priceSign: String, onIncrement: @escaping () -> Void, onDecrement: @escaping () -> Void, onOpenCart: @escaping () -> Void) {
    self.quantity = quantity
    self.priceValue = priceValue
    self.priceSign = priceSign
    self.onIncrement = onIncrement
    self.onDecrement = onDecrement
    self.onOpenCart = onOpenCart
  }

  private enum Configuration {
    static let addTitle = "В корзину"
    static let inCartTitle = "В корзине"
  }

  private enum Layout {
    static let elementsSpacing: CGFloat = 8
  }

  public var body: some View {
    switch quantity {
    case 1...:
      HStack(spacing: Layout.elementsSpacing) {
        DSProductStepper(
          quantity: quantity,
          priceValue: priceValue,
          priceSign: priceSign,
          size: .large,
          value: .quantity,
          variant: .standart,
          width: .fill,
          onIncrement: onIncrement,
          onDecrement: onDecrement
        )
        Button(action: onOpenCart) {
          Text(Configuration.inCartTitle)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(DSButtonStyle(size: .large, style: .accent))
        .accessibilityLabel(Configuration.inCartTitle)
        .accessibilityHint("Открывает корзину")
      }
    default:
      Button(action: onIncrement) {
        Text(Configuration.addTitle)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(DSButtonStyle(size: .large, style: .accent))
    }
  }
}

#Preview {
  @Previewable @State var quantity = 0
  VStack(spacing: 16) {
    DSProductDetailedButton(quantity: quantity, priceValue: 900, priceSign: "₽", onIncrement: { quantity += 1 }, onDecrement: { quantity -= 1 }, onOpenCart: {})
  }
  .padding()
}
