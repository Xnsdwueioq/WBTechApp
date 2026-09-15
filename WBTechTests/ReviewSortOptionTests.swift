//

import Foundation
import Testing
@testable import WBTech

struct ReviewSortOptionTests {

  @Test func sortsReviewsByDate() {
    let old = makeReview(author: "Старый", rating: 5, day: 1)
    let middle = makeReview(author: "Средний", rating: 1, day: 2)
    let new = makeReview(author: "Новый", rating: 3, day: 3)
    let reviews = [middle, old, new]

    #expect(ReviewSortOption.newest.sort(reviews).map(\.author) == ["Новый", "Средний", "Старый"])
    #expect(ReviewSortOption.oldest.sort(reviews).map(\.author) == ["Старый", "Средний", "Новый"])
  }

  @Test func sortsReviewsByRatingAndUsesNewestFirstForEqualRatings() {
    let oldFive = makeReview(author: "Старая пятёрка", rating: 5, day: 1)
    let newFive = makeReview(author: "Новая пятёрка", rating: 5, day: 3)
    let three = makeReview(author: "Тройка", rating: 3, day: 2)
    let reviews = [oldFive, three, newFive]

    #expect(
      ReviewSortOption.highestRated.sort(reviews).map(\.author)
        == ["Новая пятёрка", "Старая пятёрка", "Тройка"]
    )
    #expect(
      ReviewSortOption.lowestRated.sort(reviews).map(\.author)
        == ["Тройка", "Новая пятёрка", "Старая пятёрка"]
    )
  }

  private func makeReview(author: String, rating: Double, day: Int) -> Review {
    Review(
      rating: rating,
      author: author,
      createdAt: Date(timeIntervalSince1970: TimeInterval(day)),
      content: "",
      images: []
    )
  }
}
