// CartTitleItemsView.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 19.07.2026.

import SwiftUI
import UISystem

struct CartTitleItemsView: View {
  let listTitle: String?
  let availableItems: [CartLine]
  let unavailableItems: [CartLine]
  let quantity: (String) -> Int
  let onIncrement: (String) -> Void
  let onDecrement: (String) -> Void
  let onUnavailableTap: (String) -> Void

  private enum Configuration {
    static let itemListVerticalSpacing: CGFloat = 20
    static let listTopPadding: CGFloat = 10
    static let listHorizontalPadding: CGFloat = 12
    static let listBottomPadding: CGFloat = 20
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Configuration.itemListVerticalSpacing) {
      switch availableItems.count {
      case 0:
        ContentUnavailableView("Нет добавленных товаров", systemImage: "tray")
      default:
        CartItemsListView(
          title: listTitle,
          items: availableItems,
          quantity: quantity,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
          onUnavailableTap: onUnavailableTap
        )
      }
      if !unavailableItems.isEmpty {
        CartItemsListView(
          title: "Недоступны для заказа",
          items: unavailableItems,
          quantity: quantity,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
          onUnavailableTap: onUnavailableTap
        )
      }
    }
    .padding(.top, Configuration.listTopPadding)
    .padding(.horizontal, Configuration.listHorizontalPadding)
    .padding(.bottom, Configuration.listBottomPadding)
  }
}
