//

import SwiftUI

public struct DSRatingStarsComponent: View {
  let starsNumber: Int
  let activeStarsNumber: Int

  public init(starsNumber: Int, activeStarsNumber: Int) {
    let normalizedStarsNumber = abs(starsNumber)
    self.starsNumber = normalizedStarsNumber
    self.activeStarsNumber = min(abs(activeStarsNumber), normalizedStarsNumber)
  }

  private enum Layout {
    static let starsSpacing: CGFloat = 3
  }

  public var body: some View {
    HStack(spacing: Layout.starsSpacing) {
      ForEach(0..<starsNumber, id: \.self) { index in
        DSRatingStarIcon(isActive: index < activeStarsNumber)
      }
    }
  }
}

#Preview {
  DSRatingStarsComponent(starsNumber: 6, activeStarsNumber: 2)
}
