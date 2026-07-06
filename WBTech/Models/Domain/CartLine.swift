//

import Foundation

struct CartLine: Identifiable, Sendable {
  let id: String
  let image: String
  let name: String
  let weight: Int
  let price: Int
  let quantity: Int
  let available: Bool
}
