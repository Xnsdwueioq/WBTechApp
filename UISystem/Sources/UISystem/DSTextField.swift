import SwiftUI

public enum DSTextFieldStyle {
  case primary
  
  public var backgroundColor: Color {
    switch self {
    case .primary: return DSColors.surface
    }
  }
  
  public func strokeColor(hasError: Bool) -> Color {
    return hasError ? DSColors.error : .clear
  }
}

public struct DSTextField: View {
  public var placeholder: String
  @Binding public var text: String
  public var isSecure: Bool
  public var errorMessage: String?
  public var style: DSTextFieldStyle
  
  public init(placeholder: String, text: Binding<String>, isSecure: Bool = false, errorMessage: String? = nil, style: DSTextFieldStyle = .primary) {
    self.placeholder = placeholder
    self._text = text
    self.isSecure = isSecure
    self.errorMessage = errorMessage
    self.style = style
  }
  
  private enum Configuration {
    static let cornerRadius: CGFloat = 12
    static let padding: CGFloat = 16
    static let strokeWidth: CGFloat = 1
    static let errorPaddingLeading: CGFloat = 4
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Group {
        if isSecure {
          SecureField(placeholder, text: $text)
            .font(DSTypography.body)
        } else {
          TextField(placeholder, text: $text)
            .font(DSTypography.body)
        }
      }
      .padding(Configuration.padding)
      .background(style.backgroundColor)
      .cornerRadius(Configuration.cornerRadius)
      .overlay(
        RoundedRectangle(cornerRadius: Configuration.cornerRadius)
          .stroke(style.strokeColor(hasError: errorMessage != nil), lineWidth: Configuration.strokeWidth)
      )
      
      if let error = errorMessage {
        Text(error)
          .font(DSTypography.caption)
          .foregroundColor(DSColors.error)
          .padding(.leading, Configuration.errorPaddingLeading)
      }
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    DSTextField(placeholder: "Введите логин", text: .constant(""))
    DSTextField(placeholder: "Введите пароль", text: .constant(""), isSecure: true)
    DSTextField(placeholder: "Ошибка ввода", text: .constant("invalid"), errorMessage: "Неверный формат")
  }
  .padding()
  .background(DSColors.background)
}
