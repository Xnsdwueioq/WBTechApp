//

import SwiftUI

public struct DSProductTitle: View {
  let title: String
  let weight: String
  let weightSign: String
  
  public init(title: String, weight: String, weightSign: String) {
    self.title = title
    self.weight = weight
    self.weightSign = weightSign
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
      Text(weight + weightSign)
        .font(.dsProductCardWeight)
        .foregroundStyle(Color.dsProductWeightColor)
    }
  }
}
