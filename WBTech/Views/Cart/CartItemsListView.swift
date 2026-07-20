// CartItemsListView.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 19.07.2026.

import SwiftUI
import UISystem

struct CartItemsListView: View {
  let title: String?
  let items: [CartLine]
  let quantity: (String) -> Int
  let onIncrement: (String) -> Void
  let onDecrement: (String) -> Void
  let onUnavailableTap: (String) -> Void

  private enum Configuration {
    static let contentVerticalSpacing: CGFloat = 12
    static let placeholderTitle = "15 минут • 5 товаров"
  }

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: Configuration.contentVerticalSpacing) {
        Text(title ?? Configuration.placeholderTitle)
          .font(.dsCartItemsListTitle)
          .redacted(reason: title == nil ? .placeholder : [])
        ForEach(items) { item in
          DSCartItemView(
            quantity: quantity(item.id),
            config: item.uiConfig(),
            onIncrement: { onIncrement(item.id) },
            onDecrement: { onDecrement(item.id) },
            onUnavailableTap: { onUnavailableTap(item.id) },
            onError: nil
          )
        }
      }
      Spacer()
    }
  }
}
