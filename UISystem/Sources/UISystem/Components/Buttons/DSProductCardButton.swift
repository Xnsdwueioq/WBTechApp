//

import SwiftUI

struct DSProductCardButton: View {
  let quantity: Int
  let onIncrement: () -> Void
  let onDecrement: () -> Void
  
  public init(quantity: Int, onIncrement: @escaping () -> Void, onDecrement: @escaping () -> Void) {
    self.quantity = quantity
    self.onIncrement = onIncrement
    self.onDecrement = onDecrement
  }
  
  private enum Configuration {
    static let buttonTitle = "В корзину"
  }
  
  public var body: some View {
    // TODO: Implement variable UI
    Button(action: {}, label: {
      Text(Configuration.buttonTitle)
    })
    .buttonStyle(DSButtonStyle(size: .small, style: .productCardVariant))
  }
}
