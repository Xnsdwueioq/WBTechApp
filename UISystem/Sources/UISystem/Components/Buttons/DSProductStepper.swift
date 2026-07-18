//

import SwiftUI

public enum DSStepperValue {
  case total
  case quantity
}

public enum DSStepperWidth: Equatable {
  case hug
  case fill
  case fixed(CGFloat)
}

public struct DSProductStepper: View {
  let quantity: Int
  let priceValue: Int
  let priceSign: String
  let size: DSButtonSize
  let value: DSStepperValue
  let variant: DSButtonVariant
  let width: DSStepperWidth
  let onIncrement: () -> Void
  let onDecrement: () -> Void

  public init(
    quantity: Int,
    priceValue: Int,
    priceSign: String,
    size: DSButtonSize = .small,
    value: DSStepperValue = .total,
    variant: DSButtonVariant = .accent,
    width: DSStepperWidth = .hug,
    onIncrement: @escaping () -> Void,
    onDecrement: @escaping () -> Void
  ) {
    self.quantity = quantity >= 0 ? quantity : 0
    self.priceValue = priceValue
    self.priceSign = priceSign
    self.size = size
    self.value = value
    self.variant = variant
    self.width = width
    self.onIncrement = onIncrement
    self.onDecrement = onDecrement
  }

  private enum Layout {
    static let smallElementsSpacing: CGFloat = 4
    static let largeElementsSpacing: CGFloat = 12
    static let smallHorizontalPadding: CGFloat = 12
    static let largeHorizontalPadding: CGFloat = 16
    static let smallIconWidth: CGFloat = 16
    static let largeIconWidth: CGFloat = 17
    static let valueMinWidth: CGFloat = 44
  }

  private var iconWidth: CGFloat {
    switch size {
    case .large: Layout.largeIconWidth
    case .small: Layout.smallIconWidth
    }
  }

  private var elementsSpacing: CGFloat {
    switch size {
    case .large: Layout.largeElementsSpacing
    case .small: Layout.smallElementsSpacing
    }
  }

  private var horizontalPadding: CGFloat {
    switch size {
    case .large: Layout.largeHorizontalPadding
    case .small: Layout.smallHorizontalPadding
    }
  }

  private var valueMaxWidth: CGFloat? {
    switch width {
    case .hug: nil
    case .fill, .fixed: .infinity
    }
  }

  private var containerFixedWidth: CGFloat? {
    if case .fixed(let value) = width { return value }
    return nil
  }

  private var containerMaxWidth: CGFloat? {
    width == .fill ? .infinity : nil
  }

  private var valueText: String {
    switch value {
    case .total: "\(quantity * priceValue)\(priceSign)"
    case .quantity: "\(quantity)"
    }
  }

  private var valueAccessibilityLabel: String {
    switch value {
    case .total: "В корзине \(quantity), сумма \(quantity * priceValue) \(priceSign)"
    case .quantity: "В корзине \(quantity)"
    }
  }

  public var body: some View {
    HStack(spacing: elementsSpacing) {
      Button(action: onDecrement) {
        Image.dsMinusRounded
          .resizable()
          .scaledToFit()
          .frame(width: iconWidth)
          .contentShape(Rectangle())
      }
      .accessibilityLabel("Убрать из корзины")
      Text(valueText)
        .monospacedDigit()
        .frame(minWidth: Layout.valueMinWidth, maxWidth: valueMaxWidth, alignment: .center)
        .accessibilityLabel(valueAccessibilityLabel)
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
    .foregroundStyle(variant.foregroundColor)
    .padding(.horizontal, horizontalPadding)
    .frame(width: containerFixedWidth)
    .frame(maxWidth: containerMaxWidth)
    .frame(height: size.height)
    .background(variant.backgroundView(cornerRadius: size.cornerRadius))
    .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
  }
}

#Preview {
  @Previewable @State var quantity = 2
  VStack(spacing: 16) {
    DSProductStepper(quantity: quantity, priceValue: 300, priceSign: "₽", onIncrement: { quantity += 1 }, onDecrement: { quantity -= 1 })
    DSProductStepper(quantity: quantity, priceValue: 300, priceSign: "₽", size: .large, width: .fill, onIncrement: { quantity += 1 }, onDecrement: { quantity -= 1 })
    DSProductStepper(quantity: quantity, priceValue: 300, priceSign: "₽", size: .large, value: .quantity, variant: .standart, width: .fixed(140), onIncrement: { quantity += 1 }, onDecrement: { quantity -= 1 })
  }
  .padding()
}
