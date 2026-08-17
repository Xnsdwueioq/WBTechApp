//
//  SwiftDataCartPersistence.swift
//  WBTech
//
//  Created by sye7qjm3ac on 18.08.2026.
//

import SwiftData

@Model
final class StoredCartItem {
  @Attribute(.unique) var productID: String
  var quantity: Int

  init(productID: String, quantity: Int) {
    self.productID = productID
    self.quantity = quantity
  }
}

@MainActor
final class SwiftDataCartPersistence: CartPersistenceProtocol {
  private let container: ModelContainer
  private let context: ModelContext

  init(isStoredInMemoryOnly: Bool = false) throws {
    let configuration = ModelConfiguration(
      isStoredInMemoryOnly: isStoredInMemoryOnly
    )
    let container = try ModelContainer(
      for: StoredCartItem.self,
      configurations: configuration
    )
    self.container = container
    self.context = ModelContext(container)
  }

  func saveQuantities(_ quantities: [String: Int]) throws {
    let storedItems = try context.fetch(FetchDescriptor<StoredCartItem>())
    let validQuantities = quantities.filter { $0.value > 0 }
    let storedIDs = Set(storedItems.map(\.productID))

    for item in storedItems {
      if let quantity = validQuantities[item.productID] {
        item.quantity = quantity
      } else {
        context.delete(item)
      }
    }

    for (productID, quantity) in validQuantities where !storedIDs.contains(productID) {
      context.insert(StoredCartItem(productID: productID, quantity: quantity))
    }

    try context.save()
  }

  func loadQuantities() throws -> [String: Int] {
    let storedItems = try context.fetch(FetchDescriptor<StoredCartItem>())
    return storedItems.reduce(into: [:]) { result, item in
      guard item.quantity > 0 else { return }
      result[item.productID] = item.quantity
    }
  }

  func clear() throws {
    let storedItems = try context.fetch(FetchDescriptor<StoredCartItem>())
    storedItems.forEach(context.delete)
    try context.save()
  }
}

@MainActor
final class InMemoryCartPersistence: CartPersistenceProtocol {
  private var quantities: [String: Int]

  init(quantities: [String: Int] = [:]) {
    self.quantities = quantities
  }

  func saveQuantities(_ quantities: [String: Int]) throws {
    self.quantities = quantities.filter { $0.value > 0 }
  }

  func loadQuantities() throws -> [String: Int] {
    quantities
  }

  func clear() throws {
    quantities = [:]
  }
}
