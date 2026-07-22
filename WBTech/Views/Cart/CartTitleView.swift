// CartTitleView.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 20.07.2026.

import SwiftUI
import UISystem

struct CartTitleView: View {
  let totalItems: Int?

  @Environment(\.dismiss) private var dismiss
  
  private enum Configuration {
    static let horizontalSpacing: CGFloat = 10
    static let totalItemsTextOpacity: CGFloat = 0.2
    static let dismissButtonHorizontalPadding: CGFloat = 8
    static let listTopPadding: CGFloat = 10
    static let listHorizontalPadding: CGFloat = 12
    static let listBottomPadding: CGFloat = 0
  }
  
  private var titleAccessibilityLabel: String {
    guard let totalItems else { return "Корзина" }
    return "Корзина, \(totalItems)"
  }
  
  var body: some View {
    HStack(spacing: Configuration.horizontalSpacing) {
      HStack(spacing: Configuration.horizontalSpacing) {
        Text("Корзина")
        Text("\(totalItems ?? 0)")
          .opacity(Configuration.totalItemsTextOpacity)
          .redacted(reason: totalItems == nil ? .placeholder : [])
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel(titleAccessibilityLabel)
      .accessibilityAddTraits(.isHeader)
      Spacer()
      DSDismissButton(action: { dismiss() }, size: .medium)
        .padding(.horizontal, Configuration.dismissButtonHorizontalPadding)
    }
    .font(.dsCartTitle)
    .padding(.top, Configuration.listTopPadding)
    .padding(.horizontal, Configuration.listHorizontalPadding)
    .padding(.bottom, Configuration.listBottomPadding)
  }
}
