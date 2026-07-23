//

import Foundation

struct Product: Identifiable, Hashable {
  let id: String
  let image: URL?
  let name: String
  let weight: Double
  let price: Int
  let rating: Double
  let reviewCount: Int
  let isFavorite: Bool
  let discount: Double
}
