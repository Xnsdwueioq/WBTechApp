//

import SwiftUI

public struct DSProductCardStepper: View {
  let price: String
  let priceSign: String
  let onIncrement: () -> Void
  let onDecrement: () -> Void
  
  public init(price: String, priceSign: String, onIncrement: @escaping () -> Void, onDecrement: @escaping () -> Void) {
    self.price = price
    self.priceSign = priceSign
    self.onIncrement = onIncrement
    self.onDecrement = onDecrement
  }
  
  private enum Layout {
    static let elementsSpacing: CGFloat = 4
  }
  
  public var body: some View { // TODO: FIX ACTIONS
    Button(action: onIncrement) {
      HStack(spacing: Layout.elementsSpacing) {
        Image.dsMinusRounded
          .resizable()
          .scaledToFit()
          .frame(width: 16)
        Text("\(price)\(priceSign)")
        Image.dsPlusRounded
          .resizable()
          .scaledToFit()
          .frame(width: 16)
      }
    }
    .buttonStyle(DSButtonStyle(size: .small, style: .accent))
  }
}
