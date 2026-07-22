//

import SwiftUI

public struct DSSkeletonText: View {
  let lines: Int
  let lastLineRatio: CGFloat

  public init(lines: Int, lastLineRatio: CGFloat = 0.6) {
    self.lines = max(lines, 0)
    self.lastLineRatio = lastLineRatio
  }

  private enum Configuration {
    static let lineHeight: CGFloat = 12
    static let lineSpacing: CGFloat = 8
    static let cornerRadius: CGFloat = 4
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: Configuration.lineSpacing) {
      ForEach(0..<lines, id: \.self) { index in
        RoundedRectangle(cornerRadius: Configuration.cornerRadius)
          .fill(Color.dsImagePlaceholderColor)
          .frame(height: Configuration.lineHeight)
          .frame(maxWidth: .infinity, alignment: .leading)
          .scaleEffect(x: isLastLine(index) ? lastLineRatio : 1, anchor: .leading)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .accessibilityHidden(true)
  }

  private func isLastLine(_ index: Int) -> Bool {
    index == lines - 1 && lines > 1
  }
}

#Preview {
  VStack(alignment: .leading, spacing: 24) {
    DSSkeletonText(lines: 3)
    DSSkeletonText(lines: 1)
  }
  .padding()
}
