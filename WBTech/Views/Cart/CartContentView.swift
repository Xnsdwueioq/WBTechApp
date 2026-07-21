// CartContentView.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 19.07.2026.

import SwiftUI
import UISystem

struct CartContentView: View {
  let summary: CartSummary?
  let availableItems: [CartLine]
  let unavailableItems: [CartLine]
  let quantity: (String) -> Int
  let address: Address?
  let isOrderEnabled: Bool
  let onIncrement: (String) -> Void
  let onDecrement: (String) -> Void
  let onOrder: () -> Void
  let onUnavailableTap: (String) -> Void
  
  private enum Configuration {
    static let contentVerticalSpacing: CGFloat = 0
    static let topPadding: CGFloat = 20
    static let dismissButtonHorizontalPadding: CGFloat = 8
  }
  
  private var listTitle: String? {
    guard let summary else { return nil }
    return "\(PluralNoun.minute.counted(summary.deliveryTime)) • \(PluralNoun.item.counted(summary.totalItems))"
  }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Configuration.contentVerticalSpacing) {
        // MARK: Cart Title
        CartTitleView(totalItems: summary?.totalItems)

        // MARK: Item Lists
        CartTitleItemsView(
          listTitle: listTitle,
          availableItems: availableItems,
          unavailableItems: unavailableItems,
          quantity: quantity,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
          onUnavailableTap: onUnavailableTap
        )
        
        if let summary, !availableItems.isEmpty {
          // MARK: Order Info
          CartOrderInfoView(
            summary: summary,
            address: address,
            isOrderEnabled: isOrderEnabled,
            onOrder: onOrder
          )
        }
      }
    }
    .padding(.top, Configuration.topPadding)
  }
}
