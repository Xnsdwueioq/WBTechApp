//

import SwiftUI

public struct DSReviewMediaButton: View {
  let icon: Image
  let title: String
  let subtitle: String
  let action: () -> Void

  public init(icon: Image, title: String, subtitle: String, action: @escaping () -> Void) {
    self.icon = icon
    self.title = title
    self.subtitle = subtitle
    self.action = action
  }

  private enum Layout {
    static let contentSpacing: CGFloat = 12
    static let textSpacing: CGFloat = 2
    static let tileSize: CGFloat = 56
    static let iconSize: CGFloat = 26
    static let tileCornerRadius: CGFloat = 12
  }

  public var body: some View {
    Button(action: action) {
      HStack(spacing: Layout.contentSpacing) {
        icon
          .renderingMode(.template)
          .resizable()
          .scaledToFit()
          .frame(width: Layout.iconSize, height: Layout.iconSize)
          .foregroundStyle(Color.dsReviewMediaIcon)
          .frame(width: Layout.tileSize, height: Layout.tileSize)
          .background(Color.dsReviewMediaTile)
          .clipShape(RoundedRectangle(cornerRadius: Layout.tileCornerRadius))

        VStack(alignment: .leading, spacing: Layout.textSpacing) {
          Text(title)
          Text(subtitle)
        }
        .font(.dsReviewMediaText)
        .foregroundStyle(Color.dsReviewSecondaryText)
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .buttonStyle(.plain)
    .accessibilityLabel(title)
  }
}

#Preview {
  VStack(spacing: 16) {
    DSReviewMediaButton(
      icon: .dsPhotoReview,
      title: "5 файлов JPG, PNG, BMP, GIF.",
      subtitle: "до 10 МБ каждый",
      action: {}
    )
    DSReviewMediaButton(
      icon: .dsVideoReview,
      title: "Видео в формате MOV, MP4.",
      subtitle: "до 300 МБ",
      action: {}
    )
  }
  .padding()
}
