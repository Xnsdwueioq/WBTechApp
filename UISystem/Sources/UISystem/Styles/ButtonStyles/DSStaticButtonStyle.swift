//

import SwiftUI

public struct DSStaticButtonStyle: ButtonStyle {
  
  public init() {}
  
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
  }
  
}
