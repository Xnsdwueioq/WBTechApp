//

import SwiftUI

struct DSProgressiveBlurViewModifier: ViewModifier {
  
  func body(content: Content) -> some View {
    content
      .blur(radius: 4)
      .mask {
        LinearGradient.dsPreviewProgressiveBlurMask
      }
  }
  
}
