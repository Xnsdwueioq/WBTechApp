//

import Foundation
@testable import WBTech

actor FakeCartService: CartServiceProtocol {
  
  var shouldThrow = false
  
  var cartToReturn: CartSummary {
    CartSummary(
      deliveryTime: 15,
      orderPrice: 1000,
      deliveryPrice: 50,
      totalPrice: 1050,
      totalItems: 2,
      items: [
        .init(id: "idproduct1", image: "productImage1", name: "product1", weight: 60, price: 200, quantity: 2, available: true),
        .init(id: "idproduct2", image: "productImage2", name: "product2", weight: 1000, price: 600, quantity: 1, available: false)
      ]
    )
  }
  private(set) var addCalls: [String] = []
  private(set) var removeCalls: [String] = []
  
  init(shouldThrow: Bool = false) {
    self.shouldThrow = shouldThrow
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
    return 1
  }
  
  func removeFromCart(id: String) async throws -> Int {
    removeCalls.append(id)
    if shouldThrow {
      throw TestError.someError
    }
    return 1
  }
  
}
