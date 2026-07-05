//

import SwiftUI

public struct DSRatingStarIcon: View {
  let isActive: Bool
  
  public init(isActive: Bool) {
    self.isActive = isActive
  }
  
  private enum Configuration {
    static let size = Font.dsRatingStar
    static let idleStar = Color.dsRatingIdleStarColor
    static let activeStar = Color.dsRatingActiveStarColor
  }
  
  public var body: some View {
    Text("★")
      .font(Configuration.size)
      .foregroundStyle(isActive ? Configuration.activeStar : Configuration.idleStar)
  }
}
