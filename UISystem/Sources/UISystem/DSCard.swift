import SwiftUI

public enum DSCardStyle {
  case primary
  
  public var backgroundColor: Color {
    switch self {
    case .primary: return DSColors.surface
    }
  }
  
  public var shadowColor: Color {
    switch self {
    case .primary: return .black.opacity(0.1)
    }
  }
}

public struct DSCard<Content: View>: View {
  public let style: DSCardStyle
  public let content: Content
  
  public init(style: DSCardStyle = .primary, @ViewBuilder content: () -> Content) {
    self.style = style
    self.content = content()
  }
  
  private enum Configuration {
    static var cornerRadius: CGFloat { 16 }
    static var padding: CGFloat { 24 }
    static var shadowRadius: CGFloat { 10 }
    static var shadowY: CGFloat { 5 }
  }
  
  public var body: some View {
    VStack(spacing: 20) {
      content
    }
    .padding(Configuration.padding)
    .background(style.backgroundColor)
    .cornerRadius(Configuration.cornerRadius)
    .shadow(color: style.shadowColor, radius: Configuration.shadowRadius, y: Configuration.shadowY)
  }
}

#Preview {
  ZStack {
    DSColors.background.ignoresSafeArea()
    
    DSCard(style: .primary) {
      Text("Пример Карточки")
        .font(DSTypography.title)
      
      Text("Здесь может быть любой контент, например, форма логина.")
        .foregroundColor(DSColors.textSecondary)
        .font(DSTypography.body)
        .multilineTextAlignment(.center)
    }
    .padding()
  }
}
