//

import SwiftUI

public enum ProductTitleStyle: Sendable {
  case card
  case detailed
  
  var titleFont: Font {
    switch self {
    case .card: return .dsProductCardTitle
    case .detailed: return .dsProductDetailedTitle
    }
  }
  
  var weightFont: Font {
    switch self {
    case .card: return .dsProductCardWeight
    case .detailed: return .dsProductDetailedWeight
    }
  }
}

public struct DSProductTitle: View {
  let title: String
  let weight: String
  let weightSign: String
  let titleStyle: ProductTitleStyle
  
  public init(title: String, weight: String, weightSign: String, titleStyle: ProductTitleStyle = .card) {
    self.title = title
    self.weight = weight
    self.weightSign = weightSign
    self.titleStyle = titleStyle
  }
  
  private enum Layout {
    static let titleWeightSpacing: CGFloat = 8
    static let lineLimit = 1
  }
  
  public var body: some View {
    HStack(spacing: Layout.titleWeightSpacing) {
      Text(title)
        .lineLimit(Layout.lineLimit)
        .truncationMode(.tail)
        .font(titleStyle.titleFont)
      Text(weight + weightSign)
        .font(titleStyle.weightFont)
        .foregroundStyle(Color.dsProductWeightColor)
    }
  }
}
