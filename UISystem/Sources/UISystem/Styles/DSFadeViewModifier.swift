//

import SwiftUI

public struct DSFadeViewModifier: ViewModifier {
  
  public init() {}
  
  public func body(content: Content) -> some View {
    content
      .mask {
        LinearGradient.dsFade
      }
  }
  
}

#Preview {
  ZStack {
    Rectangle()
      .foregroundStyle(LinearGradient.dsViolet)
      .frame(width: 200, height: 200)
      .foregroundStyle(.green)
    Circle()
      .frame(width: 200, height: 200)
      .foregroundStyle(.blue)
      .scaleEffect(0.5)
  }
  .modifier(DSFadeViewModifier())
}
