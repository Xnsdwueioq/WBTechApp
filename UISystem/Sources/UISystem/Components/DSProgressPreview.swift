//
//  DSProgressPreview.swift
//  UISystem
//
//  Created by Eyhciurmrn Zmpodackrl on 7/24/26.
//

import SwiftUI

public struct DSProgressPreview: View {
  let title: String
  let subtitle: String
  let buttonName: String
  let onClose: () -> Void
  
  public init(title: String, subtitle: String, buttonName: String, onClose: @escaping () -> Void) {
    self.title = title
    self.subtitle = subtitle
    self.buttonName = buttonName
    self.onClose = onClose
  }
  
  private enum Configuration {
    static let iconframeSize: CGFloat = 155
    static let contentSpacing: CGFloat = 16
    static let titleSpacing: CGFloat = 8
    static let topPadding: CGFloat = 20
    static let horizontalPadding: CGFloat = 20
    static let buttonBottomPadding: CGFloat = 8
    static let subtitleOpacity: CGFloat = 0.7
    static let titlesBottomPadding: CGFloat = 20
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Spacer()
        DSDismissButton(action: onClose, size: .medium, tint: Color.dsProgressPreview)
      }
      .padding(.top, Configuration.topPadding)

      Spacer()

      Image.dsCheckmark
        .renderingMode(.template)
        .resizable()
        .scaledToFit()
        .frame(
          width: Configuration.iconframeSize,
          height: Configuration.iconframeSize
        )
        .padding(.bottom, Configuration.contentSpacing)

      VStack(alignment: .leading, spacing: Configuration.titleSpacing) {
        Text(title)
          .font(.dsProgressPreviewTitle)
        Text(subtitle)
          .font(.dsProgressPreviewSubtitle)
          .opacity(Configuration.subtitleOpacity)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .foregroundStyle(Color.dsProgressPreview)
    .padding(.horizontal, Configuration.horizontalPadding)
    .padding(.bottom, Configuration.titlesBottomPadding)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(LinearGradient.dsViolet.ignoresSafeArea())
    .safeAreaInset(edge: .bottom) {
      Button(action: onClose) {
        Text(buttonName)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(DSButtonStyle(size: .large, style: .inverted))
      .padding(.horizontal, Configuration.horizontalPadding)
      .padding(.bottom, Configuration.buttonBottomPadding)
    }
  }
}

#Preview {
  DSProgressPreview(
    title: "Отзыв отправлен",
    subtitle: "Спасибо!\nСкоро мы его опубликуем",
    buttonName: "Закрыть",
    onClose: {}
  )
}
