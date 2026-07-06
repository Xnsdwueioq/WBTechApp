//

import Foundation

struct CartSummary: Sendable {
  let deliveryTime: Int
  let orderPrice: Int
  let deliveryPrice: Int
  let totalPrice: Int
  let totalItems: Int
  let items: [CartLine]
}

