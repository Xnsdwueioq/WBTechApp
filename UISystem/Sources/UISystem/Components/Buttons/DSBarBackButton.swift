//

import SwiftUI

public struct DSBarBackButton: View {
  let action: () -> Void
  
  public init(action: @escaping () -> Void) {
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      Image.dsBack
        .resizable()
        .scaledToFit()
        .frame(width: 24, height: 24)
        .foregroundStyle(Color.dsBarBackButton)
    }
      .buttonStyle(DSStaticButtonStyle())
  }
}
