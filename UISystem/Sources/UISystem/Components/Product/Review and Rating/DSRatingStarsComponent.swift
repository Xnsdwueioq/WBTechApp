//

import SwiftUI

public struct DSRatingStarsComponent: View {
  let starsNumber: Int
  let activeStarsNumber: Int
  let starFont: Font

  public init(starsNumber: Int, activeStarsNumber: Int, starFont: Font) {
    let normalizedStarsNumber = abs(starsNumber)
    self.starsNumber = normalizedStarsNumber
    self.activeStarsNumber = min(abs(activeStarsNumber), normalizedStarsNumber)
    self.starFont = starFont
  }

  private enum Layout {
    static let starsSpacing: CGFloat = 3
  }

  public var body: some View {
    HStack(spacing: Layout.starsSpacing) {
      ForEach(0..<starsNumber, id: \.self) { index in
        DSRatingStarIcon(isActive: index < activeStarsNumber)
          .font(starFont)
      }
    }
  }
}

#Preview {
  DSRatingStarsComponent(starsNumber: 6, activeStarsNumber: 2, starFont: .dsRatingStarDetailed)
}
