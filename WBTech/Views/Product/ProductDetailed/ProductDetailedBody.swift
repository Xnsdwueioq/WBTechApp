// ProductDetailedBody.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 17.07.2026.

import SwiftUI
import UISystem

struct ProductDetailedBody: View {
  let description: String?

  private enum Configuration {
    static let skeletonLines = 4
  }

  var body: some View {
    if let description {
      Text(description)
        .frame(maxWidth: .infinity, alignment: .leading)
    } else {
      DSSkeletonText(lines: Configuration.skeletonLines)
    }
  }
}
