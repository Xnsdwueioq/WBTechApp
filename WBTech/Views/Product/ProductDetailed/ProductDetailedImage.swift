//
//  ProductDetailedImage.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/17/26.
//

import SwiftUI
import UISystem

struct ProductDetailedImage: View {
  let image: URL?
  let onError: (() -> Void)?
  
  private enum Configuration {
    static let imageRatio: CGFloat = 1
    static let imageRounded: CGFloat = 20
  }
  
  var body: some View {
    Color.dsImagePlaceholderColor
      .overlay {
        DSAsyncImage(url: image, onError: { _ in onError?() })
      }
      .clipped()
      .aspectRatio(Configuration.imageRatio, contentMode: .fit)
      .clipShape(RoundedRectangle(cornerRadius: Configuration.imageRounded))
      .accessibilityHidden(true)
  }
}
