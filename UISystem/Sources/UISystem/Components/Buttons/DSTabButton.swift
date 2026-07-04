//

import SwiftUI

public struct DSTabButton: View {
  let title: String
  let isSelected: Bool
  let action: () -> Void
  
  private enum Configuration {
    static let unselectedColor = Color.dsTabFontColor
    static let selectedColor = Color.dsSelectedTabFontColor
  }
  
  public init(title: String, isSelected: Bool, action: @escaping () -> Void) {
    self.title = title
    self.isSelected = isSelected
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      Text(title)
        .font(Font.dsTabTitle)
        .foregroundStyle(isSelected ? Configuration.selectedColor : Configuration.unselectedColor)
    }
    .buttonStyle(DSStaticButtonStyle())
  }
}
