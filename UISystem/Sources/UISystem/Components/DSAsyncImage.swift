//

import SwiftUI
import Nuke
import NukeUI

public enum DSImageSize: Sendable {
  case card
  case detailed
}

public struct DSAsyncImage: View {
  let url: URL?
  let size: DSImageSize
  let onError: ((Error) -> Void)?

  private enum Configuration {
    static let cardPixelSize: CGFloat = 500
    static let detailedPixelSize: CGFloat = 1200
  }
  
  public init(
    url: URL?,
    size: DSImageSize = .card,
    onError: ((Error) -> Void)? = nil
  ) {
    self.url = url
    self.size = size
    self.onError = onError
  }
  
  public var body: some View {
    if let request = imageRequest {
      LazyImage(
        request: request,
        transaction: Transaction(animation: .spring(duration: 0.25))
      ) { state in
        if let image = state.image {
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .transition(.opacity)
        } else if let error = state.error {
          DSFallbackImage()
            .onAppear {
              onError?(error)
            }
        } else {
          DSImageLoadingView()
        }
      }
    } else {
      DSFallbackImage()
    }
  }

  private var imageRequest: ImageRequest? {
    guard let url else { return nil }

    var request = ImageRequest(url: url)
    request.thumbnail = ImageRequest.ThumbnailOptions(
      size: targetPixelSize,
      unit: .pixels,
      contentMode: .aspectFill
    )
    return request
  }

  private var targetPixelSize: CGSize {
    let side: CGFloat = switch size {
    case .card: Configuration.cardPixelSize
    case .detailed: Configuration.detailedPixelSize
    }
    return CGSize(width: side, height: side)
  }
}

public struct DSFallbackImage: View {
  public var body: some View {
    ZStack {
      Image(systemName: "wifi.square")
    }
  }
}

public struct DSImageLoadingView: View {
  public var body: some View {
    ZStack {
      Color.clear
    }
  }
}
