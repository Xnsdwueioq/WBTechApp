//

import SwiftUI

public struct DSProductStepper: View {
  let quantity: Int
  let priceValue: Int
  let priceSign: String
  let size: DSButtonSize
  let onIncrement: () -> Void
  let onDecrement: () -> Void

  public init(quantity: Int, priceValue: Int, priceSign: String, size: DSButtonSize = .small, onIncrement: @escaping () -> Void, onDecrement: @escaping () -> Void) {
    self.quantity = quantity >= 0 ? quantity : 0
    self.priceValue = priceValue
    self.priceSign = priceSign
    self.size = size
    self.onIncrement = onIncrement
    self.onDecrement = onDecrement
  }

  private enum Layout {
    static let elementsSpacing: CGFloat = 4
    static let horizontalPadding: CGFloat = 12
    static let smallIconWidth: CGFloat = 16
    static let largeIconWidth: CGFloat = 20
    static let priceMinWidth: CGFloat = 44
  }


  private var isExpanding: Bool {
    switch size {
    case .large: return true
    case .small: return false
    }
  }

  private var iconWidth: CGFloat {
    isExpanding ? Layout.largeIconWidth : Layout.smallIconWidth
  }

  public var body: some View {
    HStack(spacing: Layout.elementsSpacing) {
      Button(action: onDecrement) {
        Image.dsMinusRounded
          .resizable()
          .scaledToFit()
          .frame(width: iconWidth)
          .contentShape(Rectangle())
      }
      .accessibilityLabel("Убрать из корзины")
      Text("\(quantity * priceValue)\(priceSign)")
        .monospacedDigit()
        .frame(minWidth: Layout.priceMinWidth, maxWidth: isExpanding ? .infinity : nil, alignment: .center)
        .accessibilityLabel("В корзине \(quantity), сумма \(quantity * priceValue) \(priceSign)")
      Button(action: onIncrement) {
        Image.dsPlusRounded
          .resizable()
          .scaledToFit()
          .frame(width: iconWidth)
          .contentShape(Rectangle())
      }
      .accessibilityLabel("Добавить ещё один")
    }
    .buttonStyle(.plain)
    .font(size.font)
    .foregroundStyle(DSButtonVariant.accent.foregroundColor)
    .padding(.horizontal, Layout.horizontalPadding)
    .frame(height: size.height)
    .background(DSButtonVariant.accent.backgroundView(cornerRadius: size.cornerRadius))
    .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
  }
}

#Preview {
  @Previewable @State var quantity = 2
  VStack(spacing: 16) {
    DSProductStepper(quantity: quantity, priceValue: 300, priceSign: "₽", onIncrement: { quantity += 1 }, onDecrement: { quantity -= 1 })
    DSProductStepper(quantity: quantity, priceValue: 300, priceSign: "₽", size: .large, onIncrement: { quantity += 1 }, onDecrement: { quantity -= 1 })
  }
  .padding()
}
