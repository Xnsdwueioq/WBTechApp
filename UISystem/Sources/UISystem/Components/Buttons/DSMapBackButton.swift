//
//  DSMapBackButton.swift
//  UISystem
//
//  Created by sye7qjm3ac on 18.08.2026.
//

import SwiftUI

public struct DSMapBackButton: View {
  private enum Layout {
    static let buttonSize: CGFloat = 40
    static let iconWidth: CGFloat = 23
    static let iconHeight: CGFloat = 22
  }

  private let action: () -> Void

  public init(action: @escaping () -> Void) {
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      Image.dsLeftArrow
        .resizable()
        .scaledToFit()
        .frame(width: Layout.iconWidth, height: Layout.iconHeight)
        .foregroundStyle(Color.dsMapControlSecondaryForeground)
        .frame(width: Layout.buttonSize, height: Layout.buttonSize)
    }
    .buttonStyle(DSMapControlButtonStyle())
    .accessibilityLabel("Назад")
  }
}

#Preview {
  DSMapBackButton {}
}
