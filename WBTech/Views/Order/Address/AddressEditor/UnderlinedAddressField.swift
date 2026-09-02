//
//  UnderlinedAddressField.swift
//  WBTech
//
//  Created by sye7qjm3ac on 19.08.2026.
//

import SwiftUI
import UISystem

struct UnderlinedAddressField: View {
  let title: String
  @Binding var text: String
  var axis: Axis = .horizontal
  
  private enum Configuration {
    static let spacing: CGFloat = 2
    static let separatorHeight: CGFloat = 1
    static let singleLineLimit = 1...1
    static let commentLineLimit = 1...3
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Configuration.spacing) {
      Text(title)
        .font(.dsAddressDetailsFieldLabel)
        .foregroundStyle(Color.dsAddressDetailsFieldLabel)
        .opacity(!text.isEmpty ? 1 : 0)
        .animation(.easeInOut, value: text.isEmpty)

      TextField(
        "",
        text: $text,
        prompt: Text(title)
          .foregroundStyle(Color.dsAddressDetailsFieldLabel),
        axis: axis
      )
      .font(.dsAddressDetailsFieldValue)
      .lineLimit(
        axis == .vertical
          ? Configuration.commentLineLimit
          : Configuration.singleLineLimit
      )
      .accessibilityLabel(title)

      Rectangle()
        .fill(Color.dsAddressDetailsFieldSeparator)
        .frame(height: Configuration.separatorHeight)
    }
  }
}
