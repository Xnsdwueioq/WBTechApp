//

import Foundation
@testable import WBTech

actor FakeCartService: CartServiceProtocol {
  
  var shouldThrow = false
  private var quantities: [String: Int]
  
  var cartToReturn: CartSummary {
    let items = quantities
      .filter { $0.value > 0 }
      .map { id, quantity in
        CartLine(
          id: id,
          image: "\(id)-image",
          name: id,
          weight: 100,
          price: 200,
          quantity: quantity,
          available: id != "idproduct2"
        )
      }
      .sorted { $0.id < $1.id }

    return CartSummary(
      deliveryTime: 15,
      orderPrice: 1000,
      deliveryPrice: 50,
      totalPrice: 1050,
      totalItems: quantities.values.reduce(0, +),
      items: items
    )
  }
  private(set) var addCalls: [String] = []
  private(set) var decrementCalls: [String] = []
  
  init(
    shouldThrow: Bool = false,
    quantities: [String: Int] = ["idproduct1": 2, "idproduct2": 1]
  ) {
    self.shouldThrow = shouldThrow
    self.quantities = quantities
  }
  
  func fetchCart() async throws -> CartSummary {
    if shouldThrow {
      throw TestError.someError
    }
    return cartToReturn
  }
  
  func addToCart(id: String) async throws -> Int {
    addCalls.append(id)
    if shouldThrow {
      throw TestError.someError
    }
    quantities[id, default: 0] += 1
    return quantities.values.reduce(0, +)
  }
  
  func decrementCartItem(id: String) async throws -> Int {
    decrementCalls.append(id)
    if shouldThrow {
      throw TestError.someError
    }
    if quantities[id, default: 0] > 1 {
      quantities[id, default: 0] -= 1
    } else {
      quantities[id] = nil
    }
    return quantities.values.reduce(0, +)
  }
  
}
