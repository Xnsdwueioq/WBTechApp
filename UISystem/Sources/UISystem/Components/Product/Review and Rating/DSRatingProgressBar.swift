//
//  DSRatingProgressBar.swift
//  UISystem
//
//  Created by Eyhciurmrn Zmpodackrl on 7/22/26.
//

import SwiftUI

public struct DSRatingProgressBar: View {
  let current: Int
  let total: Int

  public init(current: Int, total: Int) {
    let normalizedTotal = max(total, 0)
    self.total = normalizedTotal
    self.current = min(max(current, 0), normalizedTotal)
  }

  private enum Layout {
    static let height: CGFloat = 2
  }

  private var progress: CGFloat {
    guard total > 0 else { return 0 }
    return CGFloat(current) / CGFloat(total)
  }

  public var body: some View {
    Capsule()
      .fill(Color.dsRatingLine)
      .frame(height: Layout.height)
      .overlay(alignment: .leading) {
        GeometryReader { proxy in
          Capsule()
            .fill(Color.dsRatingActiveStarColor)
            .frame(width: proxy.size.width * progress)
        }
      }
      .accessibilityHidden(true)
  }
}

#Preview {
  VStack(spacing: 12) {
    DSRatingProgressBar(current: 12, total: 12)
    DSRatingProgressBar(current: 7, total: 12)
    DSRatingProgressBar(current: 1, total: 12)
    DSRatingProgressBar(current: 0, total: 12)
    DSRatingProgressBar(current: 5, total: 0)
  }
  .padding()
}
