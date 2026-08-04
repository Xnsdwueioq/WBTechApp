//
// DSErrorView.swift
// UISystem
//

import SwiftUI

public struct DSErrorView: View {
  let title: String
  let description: String?
  let systemImage: String
  let buttonTitle: String
  let buttonStyle: DSButtonVariant
  let onRetry: (() -> Void)?
  
  public init(
    title: String = "Не удалось загрузить данные",
    description: String? = "Проверьте подключение к интернету и попробуйте снова",
    systemImage: String = "wifi.slash",
    buttonTitle: String = "Повторить",
    buttonStyle: DSButtonVariant = .accent,
    onRetry: (() -> Void)? = nil
  ) {
    self.title = title
    self.description = description
    self.systemImage = systemImage
    self.buttonTitle = buttonTitle
    self.buttonStyle = buttonStyle
    self.onRetry = onRetry
  }
  
  private enum Layout {
    static let verticalSpacing: CGFloat = 16
    static let iconSize: CGFloat = 44
    static let maxContentWidth: CGFloat = 300
    static let buttonPaddingTop: CGFloat = 8
  }
  
  public var body: some View {
    VStack(spacing: Layout.verticalSpacing) {
      Image(systemName: systemImage)
        .font(.system(size: Layout.iconSize, weight: .regular))
        .foregroundStyle(.secondary)
      
      VStack(spacing: 6) {
        Text(title)
          .font(.dsCatalogGroupTitle)
          .multilineTextAlignment(.center)
          .foregroundStyle(.primary)
        
        if let description {
          Text(description)
            .font(.dsSmallStandart)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
        }
      }
      .frame(maxWidth: Layout.maxContentWidth)
      
      if let onRetry {
        Button(action: onRetry) {
          Text(buttonTitle)
        }
        .buttonStyle(DSButtonStyle(size: .small, style: buttonStyle))
        .padding(.top, Layout.buttonPaddingTop)
      }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  DSErrorView(onRetry: {})
}
