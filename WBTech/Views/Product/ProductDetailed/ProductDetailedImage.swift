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
    DSAsyncImage(url: image, onError: { print($0.localizedDescription) })
      .aspectRatio(Configuration.imageRatio, contentMode: .fill)
      .clipShape(RoundedRectangle(cornerRadius: Configuration.imageRounded))
      .accessibilityHidden(true)
  }
}
