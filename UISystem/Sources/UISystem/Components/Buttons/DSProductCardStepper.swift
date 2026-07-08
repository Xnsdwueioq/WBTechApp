//

import SwiftUI

public struct DSProductCardStepper: View {
  let quantity: Int
  let priceValue: Int
  let priceSign: String
  let onIncrement: () -> Void
  let onDecrement: () -> Void
  
  public init(quantity: Int, priceValue: Int, priceSign: String, onIncrement: @escaping () -> Void, onDecrement: @escaping () -> Void) {
    self.quantity = quantity >= 0 ? quantity : 0
    self.priceValue = priceValue
    self.priceSign = priceSign
    self.onIncrement = onIncrement
    self.onDecrement = onDecrement
  }
  
  private enum Layout {
    static let elementsSpacing: CGFloat = 4
    static let horizontalPadding: CGFloat = 12
    static let iconWidth: CGFloat = 16
    static let priceMinWidth: CGFloat = 44
  }

  public var body: some View {
    HStack(spacing: Layout.elementsSpacing) {
      Button(action: onDecrement) {
        Image.dsMinusRounded
          .resizable()
          .scaledToFit()
          .frame(width: Layout.iconWidth)
          .contentShape(Rectangle())
      }
      .accessibilityLabel("Убрать из корзины")
      Text("\(quantity * priceValue)\(priceSign)")
        .monospacedDigit()
        .frame(minWidth: Layout.priceMinWidth, alignment: .center)
        .accessibilityLabel("В корзине \(quantity), сумма \(quantity * priceValue) \(priceSign)")
      Button(action: onIncrement) {
        Image.dsPlusRounded
          .resizable()
          .scaledToFit()
          .frame(width: Layout.iconWidth)
          .contentShape(Rectangle())
      }
      .accessibilityLabel("Добавить ещё один")
    }
    .buttonStyle(.plain)
    .font(DSButtonSize.small.font)
    .foregroundStyle(DSButtonVariant.accent.foregroundColor)
    .padding(.horizontal, Layout.horizontalPadding)
    .frame(height: DSButtonSize.small.height)
    .background(DSButtonVariant.accent.backgroundView(cornerRadius: DSButtonSize.small.cornerRadius))
    .clipShape(RoundedRectangle(cornerRadius: DSButtonSize.small.cornerRadius))
  }
}

#Preview {
  @Previewable @State var quantity = 2
  DSProductCardStepper(quantity: quantity, priceValue: 300, priceSign: "$", onIncrement: {quantity += 1}, onDecrement: {quantity -= 1})
}
