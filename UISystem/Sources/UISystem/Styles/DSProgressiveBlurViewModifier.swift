//

import SwiftUI

public struct DSProgressiveBlurViewModifier: ViewModifier {
  
  public func body(content: Content) -> some View {
    content
      .blur(radius: 4)
      .mask {
        LinearGradient.dsPreviewProgressiveBlurMask
      }
  }
  
}
