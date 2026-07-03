//

import SwiftUI

public enum DSButtonSize {
  case large
  case small
  
  public var height: CGFloat {
    switch self {
    case .large: return 50
    case .small: return 32
    }
  }
  
  public var cornerRadius: CGFloat {
    switch self {
    case .large: return 12
    case .small: return 8
    }
  }
  
  public var font: Font {
    switch self {
    case .large: return .dsLargeStandart
    case .small: return .dsSmallStandart
    }
  }
}

public enum DSButtonVariant: CaseIterable {
  case accent
  case accentDisabled
  case standart
  case productCardVariant
  case surface
  case outline
}

public extension DSButtonVariant {
  
  var foregroundColor: Color {
    switch self {
    case .accent: .dsAccentButtonForeground
    case .accentDisabled: .dsAccentDisabledButtonForeground
    case .standart: .dsStandartButtonForeground
    case .productCardVariant: .dsProductCardButtonButtonForeground
    case .surface: .dsSurfaceButtonForeground
    case .outline: .dsOutlineButtonForeground
    }
  }
  
}

public extension DSButtonVariant {
  
  @ViewBuilder
  func backgroundView(cornerRadius: CGFloat) -> some View {
    switch self {
    case .accent:
      LinearGradient.dsViolet
    case .accentDisabled:
      Color.dsAccentDisabledButtonBackground
    case .standart:
      Color.dsStandartButtonBackground
    case .productCardVariant:
      LinearGradient.dsProductCard
    case .surface:
      ZStack {
        RoundedRectangle(cornerRadius: cornerRadius)
          .foregroundStyle(.ultraThinMaterial)
          .blur(radius: 1)
          .opacity(0.95)
        RoundedRectangle(cornerRadius: cornerRadius)
          .strokeBorder(Color.dsSurfaceButtonBorder, lineWidth: 1)
      }
    case .outline:
      Color.dsOutlineButtonBackground
        .overlay(
          RoundedRectangle(cornerRadius: cornerRadius)
            .strokeBorder(LinearGradient.dsProductCard, lineWidth: 2)
        )
    }
  }
  
}

public struct DSButtonStyle: ButtonStyle {
  let size: DSButtonSize
  let style: DSButtonVariant
  
  public init(size: DSButtonSize, style: DSButtonVariant) {
    self.size = size
    self.style = style
  }
  
  private enum Layout {
    static let horizontalPadding: CGFloat = 6
  }
  
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(size.font)
      .foregroundStyle(style.foregroundColor)
      .padding(.horizontal, Layout.horizontalPadding)
      .frame(height: size.height)
      .background(style.backgroundView(cornerRadius: size.cornerRadius))
      .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  ZStack {
    ScrollView {
      Circle()
        .frame(width: 800)
        .foregroundStyle(.green)
      Text("SOME TEXT")
    }
    VStack {
      ForEach(DSButtonVariant.allCases, id:\.self) { variant in
        Button(action: {}, label: {
          Text("Заказать")
        })
        .buttonStyle(DSButtonStyle(size: .large, style: variant))
        Button(action: {}, label: { Text("Заказать") })
          .buttonStyle(DSButtonStyle(size: .small, style: variant))
      }
    }
  }
  
}
