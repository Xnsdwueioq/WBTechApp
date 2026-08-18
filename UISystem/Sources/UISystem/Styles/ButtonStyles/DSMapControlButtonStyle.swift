//
//  DSMapControlButtonStyle.swift
//  UISystem
//
//  Created by sye7qjm3ac on 18.08.2026.
//

import SwiftUI

public struct DSMapControlButtonStyle: ButtonStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .modifier(DSMapControlBackgroundViewModifier())
  }
}
