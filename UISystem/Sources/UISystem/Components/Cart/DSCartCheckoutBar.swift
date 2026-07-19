// DSCartCheckoutBar.swift
// UISystem
// Created by Eyhciurmrn Zmpodackrl on 20.07.2026.

import SwiftUI

public struct DSCartCheckoutBar: View {
  let price: String
  let priceSign: String
  let itemsTitle: String
  let onCheckout: () -> Void

  public init(
    price: String,
    priceSign: String,
    itemsTitle: String,
    onCheckout: @escaping () -> Void
  ) {
    self.price = price
    self.priceSign = priceSign
    self.itemsTitle = itemsTitle
    self.onCheckout = onCheckout
  }

  private enum Configuration {
    static let checkoutTitle = "Оформить"
    static let contentSpacing: CGFloat = 12
    static let priceSignSpacing: CGFloat = 1
    static let summarySpacing: CGFloat = 0
    static let horizontalPadding: CGFloat = 20
    static let cornerRadius: CGFloat = 50
    static let height: CGFloat = DSButtonSize.large.height
  }

  private var accessibilityLabel: String {
    "Корзина, \(itemsTitle), \(price) \(priceSign)"
  }

  public var body: some View {
    Button(action: onCheckout) {
      HStack(spacing: Configuration.contentSpacing) {
        VStack(alignment: .leading, spacing: Configuration.summarySpacing) {
          HStack(alignment: .bottom, spacing: Configuration.priceSignSpacing) {
            Text(price)
              .font(.dsCartCheckoutPrice)
            Text(priceSign)
              .font(.dsCartCheckoutPriceSign)
          }
          Text(itemsTitle)
            .font(.dsCartCheckoutItems)
        }
        Spacer()
        Text(Configuration.checkoutTitle)
          .font(.dsCartCheckoutTitle)
      }
      .foregroundStyle(Color.dsCartCheckoutForeground)
      .padding(.horizontal, Configuration.horizontalPadding)
      .frame(maxWidth: .infinity, minHeight: Configuration.height)
      .background {
        LinearGradient.dsViolet
      }
      .clipShape(RoundedRectangle(cornerRadius: Configuration.cornerRadius))
      .contentShape(.rect)
    }
    .buttonStyle(.plain)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(accessibilityLabel)
    .accessibilityHint("Открывает корзину")
  }
}

#Preview {
  VStack(spacing: 20) {
    DSCartCheckoutBar(price: "1230", priceSign: "₽", itemsTitle: "3 товара", onCheckout: {})
    DSCartCheckoutBar(price: "99", priceSign: "₽", itemsTitle: "1 товар", onCheckout: {})
  }
  .padding()
}
