import SwiftUI
import UISystem

struct OrderDetailsView: View {
  let order: Order
  let etaMinutes: Int
  let isRepeatingOrder: Bool
  let onClose: () -> Void
  let onDownloadReceipt: () -> Void
  let onRepeatOrder: () -> Void

  init(
    order: Order,
    etaMinutes: Int = 12,
    isRepeatingOrder: Bool = false,
    onClose: @escaping () -> Void,
    onDownloadReceipt: @escaping () -> Void,
    onRepeatOrder: @escaping () -> Void
  ) {
    self.order = order
    self.etaMinutes = etaMinutes
    self.isRepeatingOrder = isRepeatingOrder
    self.onClose = onClose
    self.onDownloadReceipt = onDownloadReceipt
    self.onRepeatOrder = onRepeatOrder
  }

  private enum Configuration {
    static let horizontalPadding: CGFloat = 12
    static let topPadding: CGFloat = 18
    static let contentSpacing: CGFloat = 16
    static let addressSpacing: CGFloat = 2
    static let itemSpacing: CGFloat = 12
    static let itemDetailsSpacing: CGFloat = 4
    static let imageSize: CGFloat = 100
    static let imageCornerRadius: CGFloat = 8
    static let summarySpacing: CGFloat = 2
    static let summaryBottomPadding: CGFloat = 4
    static let buttonsSpacing: CGFloat = 8
    static let bottomPadding: CGFloat = 12
    static let dismissTapArea: CGFloat = 44
    static let dismissTopPadding: CGFloat = 4
    static let priceSign = "₽"
    static let weightSign = "г"
    static let quantitySign = "шт"
    static let totalTitle = "Итого"
    static let deliveryTitle = "Доставка"
    static let freeDeliveryTitle = "Бесплатно"
    static let downloadReceiptTitle = "Скачать чек"
    static let repeatOrderTitle = "Повторить заказ"
  }

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        LazyVStack(alignment: .leading, spacing: Configuration.contentSpacing) {
          Text(order.statusTitle(etaMinutes: etaMinutes))
            .font(.dsPrimaryTitle)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.trailing, Configuration.dismissTapArea)
            .accessibilityAddTraits(.isHeader)

          addressView

          ForEach(order.items) { item in
            orderItemView(item)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Configuration.topPadding)
      }

      footer
    }
    .padding(.horizontal, Configuration.horizontalPadding)
    .padding(.bottom, Configuration.bottomPadding)
    .background(Color(.systemBackground))
    .overlay(alignment: .topTrailing) {
      DSDismissButton(action: onClose, size: .medium)
        .frame(
          width: Configuration.dismissTapArea,
          height: Configuration.dismissTapArea
        )
        .padding(.top, Configuration.dismissTopPadding)
    }
  }

  private var addressView: some View {
    DSAddressView(
      address: order.address.uiConfig(),
      withChevron: false,
      style: .orderDetails
    )
  }

  private func orderItemView(_ item: OrderItem) -> some View {
    HStack(alignment: .top, spacing: Configuration.itemSpacing) {
      DSAsyncImage(url: URL(string: item.image), size: .card)
        .frame(
          width: Configuration.imageSize,
          height: Configuration.imageSize
        )
        .clipShape(RoundedRectangle(cornerRadius: Configuration.imageCornerRadius))
        .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: Configuration.itemDetailsSpacing) {
        Text("\(item.price) \(Configuration.priceSign), \(item.quantity) \(Configuration.quantitySign)")
          .font(.dsCartInfoPrimary)

        HStack(alignment: .firstTextBaseline, spacing: Configuration.itemDetailsSpacing) {
          Text(item.name)
            .foregroundStyle(.primary)
            .lineLimit(2)

          Text("\(item.weight) \(Configuration.weightSign)")
            .foregroundStyle(Color.dsTabFontColor)
            .fixedSize()
        }
        .font(.dsProductCardTitle)
      }
      .padding(.top, Configuration.addressSpacing)

      Spacer(minLength: 0)
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(
      "\(item.name), \(item.weight) \(Configuration.weightSign), \(item.price) \(Configuration.priceSign), \(item.quantity) \(Configuration.quantitySign)"
    )
  }

  private var footer: some View {
    VStack(alignment: .leading, spacing: Configuration.contentSpacing) {
      VStack(alignment: .leading, spacing: Configuration.summarySpacing) {
        HStack {
          Text(Configuration.totalTitle)
          Spacer()
          Text(priceText(order.totalPrice))
        }
        .font(.dsCartInfoPrimary)
        .padding(.bottom, Configuration.summaryBottomPadding)
        .accessibilityElement(children: .combine)

        HStack {
          Text(PluralNoun.item.counted(order.totalItems))
          Spacer()
          Text(priceText(order.orderPrice))
        }
        .accessibilityElement(children: .combine)

        HStack {
          Text(Configuration.deliveryTitle)
          Spacer()
          Text(deliveryPriceText)
        }
        .accessibilityElement(children: .combine)
      }
      .font(.dsCartInfoSecondary)

      HStack(spacing: Configuration.buttonsSpacing) {
        Button(Configuration.downloadReceiptTitle, action: onDownloadReceipt)
          .buttonStyle(DSButtonStyle(size: .large, style: .outline))
          .disabled(isRepeatingOrder)

        Button(action: onRepeatOrder) {
          ZStack {
            Text(Configuration.repeatOrderTitle)
              .opacity(isRepeatingOrder ? 0 : 1)

            if isRepeatingOrder {
              ProgressView()
                .tint(.white)
            }
          }
        }
        .buttonStyle(DSButtonStyle(size: .large, style: .accent))
        .disabled(isRepeatingOrder)
      }
      .frame(maxWidth: .infinity, alignment: .center)
    }
  }

  private var deliveryPriceText: String {
    order.deliveryPrice == 0
      ? Configuration.freeDeliveryTitle
      : priceText(order.deliveryPrice)
  }

  private func priceText(_ price: Int) -> String {
    "\(price) \(Configuration.priceSign)"
  }
}

#Preview("Активный заказ") {
  OrderDetailsView(
    order: .mockActive,
    onClose: {},
    onDownloadReceipt: {},
    onRepeatOrder: {}
  )
}

#Preview("Завершённый заказ") {
  OrderDetailsView(
    order: .mockCompleted,
    onClose: {},
    onDownloadReceipt: {},
    onRepeatOrder: {}
  )
}
