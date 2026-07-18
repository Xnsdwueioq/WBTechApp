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
    Group {
      ForEach(availableItems) { item in
        Text(item.id)
      }
      ForEach(unavailableItems) { item in
        Text(item.id)
      }
    }
    .task {
      await store.load()
    }
  }
}

#Preview {
  CartView()
    .environment(CartStore(cartService: MockCartService()))
}
