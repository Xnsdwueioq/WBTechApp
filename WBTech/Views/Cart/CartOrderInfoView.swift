// CartOrderInfoView.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 19.07.2026.

import SwiftUI
import UISystem

struct CartOrderInfoView: View {
  let summary: CartSummary
  let onOrder: () -> Void

  private enum Configuration {
    static let topPadding: CGFloat = 16
    static let horizontalPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 24
    static let buttonContentSpacing: CGFloat = 28
    static let infoVerticalSpacing: CGFloat = 20
    static let addressLinesSpacing: CGFloat = 0
    static let paymentLinesSpacing: CGFloat = 4
    static let paymentIconSpacing: CGFloat = 6
    static let totalsSpacing: CGFloat = 2
    static let totalsRowsSpacing: CGFloat = 0
    static let totalRowBottomPadding: CGFloat = 4
    static let priceSign = "₽"
    static let freeDeliveryTitle = "Бесплатно"
  }

  private var totalPriceText: String {
    "\(summary.totalPrice) \(Configuration.priceSign)"
  }

  private var orderPriceText: String {
    "\(summary.orderPrice) \(Configuration.priceSign)"
  }

  private var deliveryPriceText: String {
    guard summary.deliveryPrice > 0 else { return Configuration.freeDeliveryTitle }
    return "\(summary.deliveryPrice) \(Configuration.priceSign)"
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Configuration.buttonContentSpacing) {
      VStack(alignment: .leading, spacing: Configuration.infoVerticalSpacing) {
        // MARK: Address
        VStack(alignment: .leading, spacing: Configuration.addressLinesSpacing) {
          HStack {
            Text("Новая Басманная ул., 35 ст1, 59")
            Image.dsChevron
          }
            .font(.dsCartInfoPrimary)
          Text("3 этаж, 4 подъезд, код домофона 15809")
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Открывает выбор адреса")

        // MARK: Payment
        VStack(alignment: .leading, spacing: Configuration.paymentLinesSpacing) {
          HStack {
            Text("Оплата картой")
            Image.dsChevron
          }
          HStack(spacing: Configuration.paymentIconSpacing) {
            Text("ICON")
            Text("••1234")
          }
        }
        .font(.dsCartInfoPrimary)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Открывает выбор способа оплаты")

        // MARK: Totals
        VStack(alignment: .leading, spacing: Configuration.totalsSpacing) {
          HStack {
            Text("Итого")
            Spacer()
            Text(totalPriceText)
          }
          .font(.dsCartInfoPrimary)
          .padding(.bottom, Configuration.totalRowBottomPadding)
          .accessibilityElement(children: .combine)
          VStack(alignment: .leading, spacing: Configuration.totalsRowsSpacing) {
            HStack {
              Text(PluralNoun.item.counted(summary.totalItems))
              Spacer()
              Text(orderPriceText)
            }
            .accessibilityElement(children: .combine)
            HStack {
              Text("Доставка")
              Spacer()
              Text(deliveryPriceText)
            }
            .accessibilityElement(children: .combine)
          }
        }
      }

      Button(action: onOrder) {
        Text("Заказать")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(DSButtonStyle(size: .large, style: .accent))

    }
    .font(.dsCartInfoSecondary)
    .padding(.top, Configuration.topPadding)
    .padding(.horizontal, Configuration.horizontalPadding)
    .padding(.bottom, Configuration.bottomPadding)
    .background {
      LinearGradient.dsProductCard
    }
  }
}
