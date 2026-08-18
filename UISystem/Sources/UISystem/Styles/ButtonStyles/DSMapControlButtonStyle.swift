//
//  DSMapControlButtonStyle.swift
//  UISystem
//
//  Created by sye7qjm3ac on 18.08.2026.
//

import SwiftUI

public struct DSMapControlButtonStyle: ButtonStyle {
  private enum Layout {
    static let cornerRadius: CGFloat = 12
    static let shadowRadius: CGFloat = 10
    static let shadowOffsetY: CGFloat = -1
  }

  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .background {
        RoundedRectangle(
          cornerRadius: Layout.cornerRadius,
          style: .continuous
        )
        .fill(Color.dsMapControlBackground)
        .shadow(
          color: Color.dsMapControlShadow,
          radius: Layout.shadowRadius,
          y: Layout.shadowOffsetY
        )
      }
      .contentShape(
        RoundedRectangle(
          cornerRadius: Layout.cornerRadius,
          style: .continuous
        )
      )
  }
}
