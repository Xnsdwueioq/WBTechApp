// DSCartItemView.swift
// UISystem
// Created by Eyhciurmrn Zmpodackrl on 19.07.2026.

import SwiftUI

public struct DSCartItemView: View {
  let quantity: Int
  let config: DSCartLineConfig
  let onIncrement: () -> Void
  let onDecrement: () -> Void
  let onUnavailableTap: () -> Void
  let onError: ((Error) -> Void)?
  
  public init(quantity: Int, config: DSCartLineConfig, onIncrement: @escaping () -> Void, onDecrement: @escaping () -> Void, onUnavailableTap: @escaping () -> Void, onError: ((Error) -> Void)?) {
    self.quantity = quantity
    self.config = config
    self.onIncrement = onIncrement
    self.onDecrement = onDecrement
    self.onUnavailableTap = onUnavailableTap
    self.onError = onError
  }
  
  private enum Configuration {
    static let imageBodySpacing: CGFloat = 12
    static let imageFrameSize: CGFloat = 120
    static let imageCornerRadius: CGFloat = 8
    static let headerElementsSpacing: CGFloat = 4
    static let titleButtonSpacing: CGFloat = 12
  }

  private var infoAccessibilityLabel: String {
    var parts: [String] = [
      config.name,
      "\(config.weight) \(config.weightSign)",
      "\(config.price) \(config.priceSign)"
    ]
    if !config.isAvailable {
      parts.append("недоступен для заказа")
    }
    return parts.joined(separator: ", ")
  }
  
  public var body: some View {
    HStack(alignment: .top, spacing: Configuration.imageBodySpacing) {
      DSAsyncImage(url: config.imageUrl, onError: onError)
        .aspectRatio(contentMode: .fill)
        .opacity(config.isAvailable ? 1 : 0.5)
        .frame(
          width: Configuration.imageFrameSize,
          height: Configuration.imageFrameSize
        )
        .clipShape(RoundedRectangle(cornerRadius: Configuration.imageCornerRadius))
        .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: Configuration.titleButtonSpacing) {
        VStack(alignment: .leading, spacing:  Configuration.headerElementsSpacing) {
          Text(config.price + " " + config.priceSign)
            .font(.dsProductCardPrice)
          DSProductTitle(title: config.name, weight: config.weight, weightSign: config.weightSign, titleStyle: .card)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(infoAccessibilityLabel)
        switch config.isAvailable {
        case true:
          DSProductStepper(
            quantity: quantity,
            priceValue: 0,
            priceSign: "",
            size: .small,
            value: .quantity,
            variant: .standart,
            width: .hug,
            onIncrement: onIncrement,
            onDecrement: onDecrement
          )
        case false:
          Button("Заменить", action: onUnavailableTap)
            .buttonStyle(DSButtonStyle(size: .small, style: .standart))
            .accessibilityHint("Подбирает замену недоступному товару")
        }
      }
    }
  }
}


#Preview {
  DSCartItemView(quantity: 3, config: DSCartLineConfig(name: "Somename", weight: "123", weightSign: "г", price: "234", priceValue: 234, priceSign: "₽", isAvailable: true, imageUrl: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUxaV7VjrC33xPiIETJJP2H0SfT6EvAeNfhQ_NcRmfN51KNFJpPC7SZ98&s=10")), onIncrement: {}, onDecrement: {}, onUnavailableTap: {}, onError: nil)
}
