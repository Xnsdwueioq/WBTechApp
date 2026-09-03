//
//  DSMapDeleteButton.swift
//  UISystem
//
//  Created by sye7qjm3ac on 18.08.2026.
//

import SwiftUI

public struct DSMapDeleteButton: View {
  private enum Layout {
    static let buttonWidth: CGFloat = 44
    static let buttonHeight: CGFloat = 38
    static let iconWidth: CGFloat = 20
    static let iconHeight: CGFloat = 21
  }

  private let action: () -> Void

  public init(action: @escaping () -> Void) {
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      Image.dsTrash
        .resizable()
        .scaledToFit()
        .frame(width: Layout.iconWidth, height: Layout.iconHeight)
        .foregroundStyle(Color.dsMapControlDestructiveForeground)
        .frame(width: Layout.buttonWidth, height: Layout.buttonHeight)
    }
    .buttonStyle(DSMapControlButtonStyle())
    .accessibilityLabel("Удалить адрес")
  }
}

#Preview {
  DSMapDeleteButton {}
}
