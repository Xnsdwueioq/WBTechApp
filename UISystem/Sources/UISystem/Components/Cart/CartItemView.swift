// CartItemView.swift
// UISystem
// Created by Eyhciurmrn Zmpodackrl on 19.07.2026.

import SwiftUI

public struct CartItemView: View {
  let title: String
  let quantity: Int
  let weight: String
  let weightSign: String
  let isAvailable: Bool
  let url: URL?
  let onIncrement: () -> Void
  let onDecrement: () -> Void
  let onError: ((Error) -> Void)?
  
  public var body: some View {
    HStack(spacing: 12) {
      DSAsyncImage(url: url, onError: onError)
        .frame(height: 120)
      VStack(alignment: .leading, spacing: 4) {
        DSProductTitle(title: title, weight: weight, weightSign: weightSign, titleStyle: .card)
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
      }
    }
  }
}


#Preview {
  CartItemView(title: "Some title", quantity: 1, weight: "100", weightSign: "г", isAvailable: true, url: URL(string: "HTTTS"), onIncrement: {}, onDecrement: {}, onError: nil)
}
