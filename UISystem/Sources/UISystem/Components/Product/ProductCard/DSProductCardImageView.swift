//

import SwiftUI

public struct DSProductCardImageView: View {
  let url: URL?
  let onError: ((Error) -> Void)?
  
  public init(url: URL?, onError: ((Error) -> Void)? = nil) {
    self.url = url
    self.onError = onError
  }
  
  private enum Configuration {
    static let imageRatio: CGFloat = 0.68
    static let cornerRadius: CGFloat = 20
  }
  
  public var body: some View {
    Color.dsImagePlaceholderColor
      .overlay {
        DSAsyncImage(url: url, onError: onError)
      }
      .clipped()
      .aspectRatio(Configuration.imageRatio, contentMode: .fit)
      .clipShape(RoundedRectangle(cornerRadius: Configuration.cornerRadius))
      .contentShape(Rectangle()) // зона нажатия строго по рамке: картинка остаётся кликабельной (для перехода в детали), но её .fill-overflow больше не крадёт тап соседнего сердечка
  }
}
