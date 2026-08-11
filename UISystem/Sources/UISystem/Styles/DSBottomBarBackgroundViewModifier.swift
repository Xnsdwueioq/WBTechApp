//

import SwiftUI

public struct DSBottomBarBackgroundViewModifier: ViewModifier {

  public init() {}

  public func body(content: Content) -> some View {
    content
      .background {
        Rectangle()
          .fill(.regularMaterial)
          .mask {
            LinearGradient.dsBottomBarMaterialMask
          }
          .ignoresSafeArea(edges: .bottom)
      }
  }
}

