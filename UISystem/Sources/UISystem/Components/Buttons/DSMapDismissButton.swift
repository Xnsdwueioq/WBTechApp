//
//  DSMapDismissButton.swift
//  UISystem
//
//  Created by sye7qjm3ac on 18.08.2026.
//

import SwiftUI

public struct DSMapDismissButton: View {
  private enum Layout {
    static let size: CGFloat = 40
  }

  private let action: () -> Void

  public init(action: @escaping () -> Void) {
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      DSDismissButtonLabel(
        size: .medium,
        tint: .dsMapControlSecondaryForeground
      )
      .frame(width: Layout.size, height: Layout.size)
    }
    .buttonStyle(DSMapControlButtonStyle())
    .accessibilityLabel("Закрыть карту")
  }
}

#Preview {
  ZStack {
    Color.green.opacity(0.15)
    DSMapDismissButton {}
  }
}
