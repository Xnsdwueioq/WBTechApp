//

import Foundation

enum ReviewSortOption: CaseIterable {
  case newest
  case oldest
  case highestRated
  case lowestRated

  var title: String {
    switch self {
    case .newest:
      return "Сначала новые"
    case .oldest:
      return "Сначала старые"
    case .highestRated:
      return "С высоким рейтингом"
    case .lowestRated:
      return "С низким рейтингом"
    }
  }

  func sort(_ reviews: [Review]) -> [Review] {
    reviews.enumerated()
      .sorted { lhs, rhs in
        if isOrderedBefore(lhs.element, rhs.element) {
          return true
        }
        if isOrderedBefore(rhs.element, lhs.element) {
          return false
        }
        return lhs.offset < rhs.offset
      }
      .map(\.element)
  }

  private func isOrderedBefore(_ lhs: Review, _ rhs: Review) -> Bool {
    switch self {
    case .newest:
      return lhs.createdAt > rhs.createdAt
    case .oldest:
      return lhs.createdAt < rhs.createdAt
    case .highestRated:
      if lhs.rating == rhs.rating {
        return lhs.createdAt > rhs.createdAt
      }
      return lhs.rating > rhs.rating
    case .lowestRated:
      if lhs.rating == rhs.rating {
        return lhs.createdAt > rhs.createdAt
      }
      return lhs.rating < rhs.rating
    }
  }
}
