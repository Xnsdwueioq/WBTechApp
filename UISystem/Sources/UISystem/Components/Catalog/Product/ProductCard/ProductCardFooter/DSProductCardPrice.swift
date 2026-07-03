//

import SwiftUI

public struct DSProductCardPrice: View {
  let price: String
  let priceSign: String
  
  public init(price: String, priceSign: String) {
    self.price = price
    self.priceSign = priceSign
  }
  
  public var body: some View {
    HStack(alignment: .bottom, spacing: 1) {
      Text(price)
        .font(.dsProductCardPrice)
      Text(priceSign)
        .font(.dsProductCardPriceSign)
      Spacer()
    }
  }
}
