import SwiftUI

public enum DSButtonStyle {
  case primary
  
  public var foregroundColor: Color {
    switch self {
    case .primary: return .white
    }
  }
  
  public var backgroundColor: Color {
    switch self {
    case .primary: return DSColors.primary
    }
  }
}

public struct DSButton: View {
  public let title: String
  public let style: DSButtonStyle
  public let action: () -> Void
  
  public init(title: String, style: DSButtonStyle = .primary, action: @escaping () -> Void) {
    self.title = title
    self.style = style
    self.action = action
  }
  
  private enum Configuration {
    static let frameHeight: CGFloat = 50
    static let frameWidth: CGFloat = .infinity
    static let cornerRadius: CGFloat = 12
  }
  
  public var body: some View {
    Button(action: action) {
      Text(title)
        .font(DSTypography.body.bold())
        .foregroundColor(style.foregroundColor)
        .frame(maxWidth: Configuration.frameWidth)
        .frame(height: Configuration.frameHeight)
        .background(style.backgroundColor)
        .cornerRadius(Configuration.cornerRadius)
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  DSButton(title: "Продолжить", style: .primary) {}
    .padding()
}
