//
//  DSChooseOnMapButton.swift
//  UISystem
//
//  Created by sye7qjm3ac on 18.08.2026.
//

import SwiftUI

public struct DSChooseOnMapButton: View {
  private enum Layout {
    static let horizontalPadding: CGFloat = 16
    static let topPadding: CGFloat = 6
    static let bottomPadding: CGFloat = 8
    static let textHeight: CGFloat = 24
  }

  private let title: LocalizedStringKey
  private let action: () -> Void

  public init(
    _ title: LocalizedStringKey = "Указать на карте",
    action: @escaping () -> Void
  ) {
    self.title = title
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      Text(title)
        .font(Font.dsMapControlTitle)
        .foregroundStyle(Color.dsMapControlForeground)
        .lineLimit(1)
        .frame(height: Layout.textHeight)
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, Layout.topPadding)
        .padding(.bottom, Layout.bottomPadding)
    }
    .buttonStyle(DSMapControlButtonStyle())
  }
}

#Preview {
  DSChooseOnMapButton {}
}
