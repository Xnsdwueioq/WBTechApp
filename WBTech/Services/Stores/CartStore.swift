//

import Foundation
import OSLog

@MainActor
@Observable
final class CartStore {
  
  private(set) var quantities: [String: Int]
  private(set) var cartSummary: CartSummary?
  private let cartService: CartServiceProtocol
  private let persistence: CartPersistenceProtocol
  private var didRestoreCachedQuantities: Bool
  
  init(
    quantities: [String: Int] = [:],
    cartService: CartServiceProtocol,
    persistence: CartPersistenceProtocol = InMemoryCartPersistence()
  ) {
    self.quantities = quantities
    self.cartSummary = nil
    self.cartService = cartService
    self.persistence = persistence
    self.didRestoreCachedQuantities = !quantities.isEmpty
  }
  
  func load() async {
    restoreCachedQuantitiesIfNeeded()

    do {
      let summary = try await cartService.fetchCart()
      quantities = Dictionary(
        uniqueKeysWithValues: summary.items.map { ($0.id, $0.quantity) }
      )
      cartSummary = summary
      saveCachedQuantities()
    } catch {
      Logger.cart.error("Unable to load the cart: \(error.localizedDescription)")
    }
  }
  
  var hasItems: Bool {
    (cartSummary?.totalItems ?? 0) > 0
  }

  func quantity(for id: String) -> Int {
    quantities[id, default: 0]
  }
  
  func increment(id: String) async {
    restoreCachedQuantitiesIfNeeded()

    let previousQuantity = quantities[id, default: 0]
    
    let newQuantity = previousQuantity + 1
    quantities[id] = newQuantity
    do {
      _ = try await cartService.addToCart(id: id)
      saveCachedQuantities()
      await load()
    } catch {
      Logger.cart.error("Unable to increase the quantity of the item in the cart: \(error.localizedDescription)")
      quantities[id] = previousQuantity
    }
  }
  
  func decrement(id: String) async {
    restoreCachedQuantitiesIfNeeded()

    let previousQuantity = quantities[id, default: 0]
    guard previousQuantity > 0 else { return }
    
    let newQuantity = previousQuantity - 1
    if newQuantity == 0 {
      quantities[id] = nil
    } else {
      quantities[id] = newQuantity
    }
    
    do {
      _ = try await cartService.decrementCartItem(id: id)
      saveCachedQuantities()
      await load()
    } catch {
      Logger.cart.error("Unable to decrease the quantity of the item in the cart: \(error.localizedDescription)")
      quantities[id] = previousQuantity
    }
  }

  private func restoreCachedQuantitiesIfNeeded() {
    guard !didRestoreCachedQuantities else { return }
    didRestoreCachedQuantities = true

    do {
      quantities = try persistence.loadQuantities()
    } catch {
      Logger.persistence.error("Unable to restore the cached cart: \(error.localizedDescription)")
    }
  }

  private func saveCachedQuantities() {
    do {
      try persistence.saveQuantities(quantities)
    } catch {
      Logger.persistence.error("Unable to cache the cart: \(error.localizedDescription)")
    }
  }

}
