//

import SwiftUI

public struct DSProductCardFooterTitle: View {
  let title: String
  let weight: String
  
  public init(title: String, weight: String) {
    self.title = title
    self.weight = weight
  }
  
  private enum Layout {
    static let titleWeightSpacing: CGFloat = 8
  }
  
  public var body: some View {
    HStack(spacing: Layout.titleWeightSpacing) {
      Text(title)
        .lineLimit(1)
        .truncationMode(.tail)
        .font(.dsProductCardTitle)
      Text(weight)
        .font(.dsProductCardWeight)
        .foregroundStyle(Color.dsProductWeightColor)
    }
  }
}
