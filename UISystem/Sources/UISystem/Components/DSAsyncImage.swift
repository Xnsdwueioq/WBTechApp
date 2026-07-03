//

import SwiftUI

public struct DSAsyncImage: View {
  let url: URL?
  let onError: ((Error) -> Void)?
  
  public init(url: URL?, onError: ((Error) -> Void)? = nil) {
    self.url = url
    self.onError = onError
  }
  
  public var body: some View {
    if let url = url {
      AsyncImage(url: url) { phase in
        switch phase {
        case .empty:
          DSImageLoadingView()
        case .success(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
        case .failure(let error):
          DSFallbackImage()
            .onAppear {
              onError?(error)
            }
        @unknown default:
          DSFallbackImage()
        }
      }
    } else {
      DSFallbackImage()
    }
  }
}

public struct DSFallbackImage: View {
  public var body: some View {
    ZStack {
      Image(systemName: "xmark.square.fill")
    }
  }
}

public struct DSImageLoadingView: View {
  public var body: some View {
    ZStack {
      ProgressView()
    }
  }
}
