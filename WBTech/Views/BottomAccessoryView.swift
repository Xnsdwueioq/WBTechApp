// BottomAccessoryView.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 20.07.2026.

import SwiftUI
import UISystem

struct BottomAccessoryView: View {
  @Environment(CartStore.self) private var cartStore
  @Environment(ModalRouter.self) private var modalRouter

  private enum Configuration {
    static let priceSign = "₽"
  }

  var body: some View {
    if let summary = cartStore.cartSummary {
      DSCartCheckoutBar(
        price: "\(summary.totalPrice)",
        priceSign: Configuration.priceSign,
        itemsTitle: PluralNoun.item.counted(summary.totalItems),
        onCheckout: { modalRouter.present(route: .cart) }
      )
    }
  }
}

#Preview {
  BottomAccessoryView()
    .environment(CartStore(cartService: MockCartService()))
    .environment(ModalRouter())
    .padding()
}
