//
//  UnderlinedAddressField.swift
//  WBTech
//
//  Created by sye7qjm3ac on 19.08.2026.
//

import SwiftUI
import UISystem

struct UnderlinedAddressField: View {
  var title: String?
  var placeholder: String
  @Binding var text: String
  var axis: Axis

  init(
    title: String? = nil,
    placeholder: String? = nil,
    text: Binding<String>,
    axis: Axis = .horizontal
  ) {
    self.title = title
    self.placeholder = placeholder ?? title ?? ""
    self._text = text
    self.axis = axis
  }
  
  private enum Layout {
    static let spacing: CGFloat = 2
    static let separatorHeight: CGFloat = 1
    static let singleLineLimit = 1...1
    static let commentLineLimit = 1...3
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Layout.spacing) {
      label
        .opacity(!text.isEmpty ? 1 : 0)
        .animation(.easeInOut, value: text.isEmpty)

      TextField(
        "",
        text: $text,
        prompt: Text(placeholder)
          .foregroundStyle(Color.dsAddressDetailsFieldLabel),
        axis: axis
      )
      .font(.dsAddressDetailsFieldValue)
      .lineLimit(axis == .vertical ? Layout.commentLineLimit : Layout.singleLineLimit)
      .accessibilityLabel(title ?? placeholder)

      Rectangle()
        .fill(Color.dsAddressDetailsFieldSeparator)
        .frame(height: Layout.separatorHeight)
    }
  }

  @ViewBuilder
  private var label: some View {
    if let title {
      Text(title)
        .font(.dsAddressDetailsFieldLabel)
        .foregroundStyle(Color.dsAddressDetailsFieldLabel)
    } else {
      Text(placeholder)
        .font(.dsAddressDetailsFieldLabel)
        .hidden()
        .accessibilityHidden(true)
    }
  }
}
