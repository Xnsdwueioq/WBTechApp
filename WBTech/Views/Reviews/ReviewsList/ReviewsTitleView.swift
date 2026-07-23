//
//  ReviewsTitleView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/22/26.
//

import SwiftUI
import UISystem

struct ReviewsTitleView: View {
  let reviewsCount: Int?
  
  @Environment(\.dismiss) private var dismiss

  private enum Configuration {
    static let horizontalSpacing: CGFloat = 10
    static let totalItemsTextOpacity: CGFloat = 0.2
    static let dismissButtonHorizontalPadding: CGFloat = 8
    static let listTopPadding: CGFloat = 10
    static let listBottomPadding: CGFloat = 0
  }
  
  private var titleAccessibilityLabel: String {
    return "Отзывы" + ", " + String(reviewsCount ?? 0)
  }
  
  var body: some View {
    HStack(spacing: Configuration.horizontalSpacing) {
      HStack(spacing: Configuration.horizontalSpacing) {
        Text("Отзывы")
        Text("\(reviewsCount ?? 0)")
          .opacity(Configuration.totalItemsTextOpacity)
          .redacted(reason: reviewsCount == nil ? .placeholder : [])
      }
      .accessibilityElement(children: .ignore)
      .accessibilityLabel(titleAccessibilityLabel)
      .accessibilityAddTraits(.isHeader)
      Spacer()
      DSDismissButton(action: { dismiss() }, size: .medium)
        .padding(.horizontal, Configuration.dismissButtonHorizontalPadding)
    }
    .font(.dsModalTitle)
    .padding(.top, Configuration.listTopPadding)
    .padding(.bottom, Configuration.listBottomPadding)
  }
}
