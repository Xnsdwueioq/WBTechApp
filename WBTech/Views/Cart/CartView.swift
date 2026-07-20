// CartView.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 18.07.2026.

import SwiftUI
import UISystem

struct CartView: View {
  
  @Environment(CartStore.self) private var store
  
  var body: some View {
    let items = store.cartSummary?.items
    let availableItems = items?.filter { $0.available } ?? []
    let unavailableItems = items?.filter { !$0.available } ?? []
    let quantities = store.quantities

    CartContentView(
      summary: store.cartSummary,
      availableItems: availableItems,
      unavailableItems: unavailableItems,
      quantity: { quantities[$0, default: 0] },
      onIncrement: { id in Task { await store.increment(id: id) } },
      onDecrement: { id in Task { await store.remove(id: id) } },
      onUnavailableTap: { _ in } // TODO: INSERT ACTION
    )
    .task {
      await store.load()
    }
  }
}

#Preview {
  CartView()
    .environment(CartStore(cartService: MockCartService()))
}
