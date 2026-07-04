//

import SwiftUI

public struct DSCategoryImageView: View {
  let url: URL?
  let onError: ((Error) -> Void)?
  
  public init(url: URL?, onError: ((Error) -> Void)? = nil) {
    self.url = url
    self.onError = onError
  }
  
  public var body: some View {
    let baseImage = DSAsyncImage(url: url, onError: onError)
    Color.dsImagePlaceholderColor
      .overlay {
        baseImage
          .modifier(DSFadeViewModifier())
          .overlay {
            baseImage
              .modifier(DSFadeViewModifier())
              .modifier(DSProgressiveBlurViewModifier())
          }
      }
      .clipped()
  }
}
