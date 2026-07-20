//

import Foundation
import OSLog

@MainActor
@Observable
final class CartStore {
  
  private(set) var quantities: [String: Int]
  private(set) var cartSummary: CartSummary?
  private let cartService: CartServiceProtocol
  
  init(quantities: [String : Int] = [:], cartService: CartServiceProtocol) {
    self.quantities = quantities
    self.cartSummary = nil
    self.cartService = cartService
  }
  
  func load() async {
    do {
      let summary = try await cartService.fetchCart()
      summary.items.forEach { item in
        quantities[item.id] = item.quantity
      }
      cartSummary = summary
    } catch {
      Logger.cart.error("Unable to load the cart: \(error.localizedDescription)")
    }
  }
  
  /// Есть ли что показывать в корзине. Считается по загруженной сводке, а не по
  /// оптимистичным `quantities`, чтобы панель не появлялась раньше своих же цифр.
  var hasItems: Bool {
    (cartSummary?.totalItems ?? 0) > 0
  }

  func quantity(for id: String) -> Int {
    quantities[id, default: 0]
  }
  
  func increment(id: String) async {
    let previousQuantity = quantities[id, default: 0]
    
    let newQuantity = previousQuantity + 1
    quantities[id] = newQuantity
    do {
      _ = try await cartService.addToCart(id: id)
      await load()
    } catch {
      Logger.cart.error("Unable to increase the quantity of the item in the cart: \(error.localizedDescription)")
      quantities[id] = previousQuantity
    }
  }
  
  func remove(id: String) async {
    let previousQuantity = quantities[id, default: 0]
    
    let newQuantity = 0
    quantities[id] = newQuantity
    do {
      _ = try await cartService.removeFromCart(id: id)
      await load()
    } catch {
      Logger.cart.error("Unable to remove the item from the cart: \(error.localizedDescription)")
      quantities[id] = previousQuantity
    }
  }

}
