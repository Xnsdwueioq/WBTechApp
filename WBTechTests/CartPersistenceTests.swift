//

import Testing
@testable import WBTech

@MainActor
struct CartPersistenceTests {

  @Test func swiftDataRoundTrip() throws {
    let persistence = try SwiftDataCartPersistence(isStoredInMemoryOnly: true)

    try persistence.saveQuantities(["product1": 2, "product2": 1])
    #expect(
      try persistence.loadQuantities() == ["product1": 2, "product2": 1]
    )

    try persistence.saveQuantities(["product1": 3])
    #expect(try persistence.loadQuantities() == ["product1": 3])

    try persistence.clear()
    #expect(try persistence.loadQuantities().isEmpty)
  }
}
