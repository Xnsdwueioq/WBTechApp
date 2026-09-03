//

import Foundation
import OSLog

struct CartUserError: Identifiable, Equatable, Sendable {
  let id = UUID()
  let title: String
  let message: String
}

@MainActor
@Observable
final class CartStore {

  private enum Configuration {
    static let loadErrorTitle = "Не удалось загрузить корзину"
    static let incrementErrorTitle = "Не удалось добавить товар"
    static let decrementErrorTitle = "Не удалось изменить количество"
    static let repeatOrderErrorTitle = "Не удалось повторить заказ"
  }
  
  private(set) var quantities: [String: Int]
  private(set) var cartSummary: CartSummary?
  private(set) var userError: CartUserError?
  private(set) var isLoading = false
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
    self.userError = nil
    self.cartService = cartService
    self.persistence = persistence
    self.didRestoreCachedQuantities = !quantities.isEmpty
  }
  
  func load() async {
    guard !isLoading else { return }

    isLoading = true
    defer { isLoading = false }

    userError = nil
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
      presentError(title: Configuration.loadErrorTitle, error: error)
    }
  }
  
  var hasItems: Bool {
    (cartSummary?.totalItems ?? 0) > 0
  }

  func quantity(for id: String) -> Int {
    quantities[id, default: 0]
  }
  
  func increment(id: String) async {
    userError = nil
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
      presentError(title: Configuration.incrementErrorTitle, error: error)
    }
  }
  
  func decrement(id: String) async {
    userError = nil
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
      presentError(title: Configuration.decrementErrorTitle, error: error)
    }
  }

  func repeatOrder(items: [OrderItem]) async -> Bool {
    userError = nil
    restoreCachedQuantitiesIfNeeded()

    do {
      for item in items where item.quantity > 0 {
        for _ in 0..<item.quantity {
          _ = try await cartService.addToCart(id: item.id)
        }
      }

      await load()
      return userError == nil
    } catch {
      Logger.cart.error("Unable to repeat the order: \(error.localizedDescription)")
      await load()
      presentError(title: Configuration.repeatOrderErrorTitle, error: error)
      return false
    }
  }

  func dismissError() {
    userError = nil
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

  private func presentError(title: String, error: Error) {
    userError = CartUserError(
      title: title,
      message: error.localizedDescription
    )
  }

}
