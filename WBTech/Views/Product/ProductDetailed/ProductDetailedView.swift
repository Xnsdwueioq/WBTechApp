//
//  ProductDetailedView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/17/26.
//

import SwiftUI
import UISystem

struct ProductDetailedView: View {
  let product: DSProductCardConfig
  let onFavoriteTap: () -> Void
  let onError: (() -> Void)?
  
  private enum Configuration {
    static let imageContentSpacing: CGFloat = 0
    static let contentSectionsSpacing: CGFloat = 16
    static let topPadding: CGFloat = 20
    static let horizontalPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 84
  }
  
  var body: some View {
    VStack(spacing: Configuration.imageContentSpacing) {
      ProductDetailedImage(image: product.imageUrl, onError: onError)
      VStack(spacing: Configuration.contentSectionsSpacing) {
        ProductDetailedHeaderView(product: product, isFavorite: true, onFavoriteTap: onFavoriteTap)
      }
      .padding(.top, Configuration.topPadding)
      .padding(.horizontal, Configuration.horizontalPadding)
      .padding(.bottom, Configuration.bottomPadding)
    }
  }
}

#Preview {
  ProductDetailedView(
    product: Product(
      id: "product1",
      image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/026c8f99-bbe3-40b4-9ef9-3c3759a857ff"),
      name: "Огурец в тесте c соусом",
      weight: 80,
      price: 750,
      rating: 3.8,
      reviewCount: 1356,
      isFavorite: false,
      discount: 0
    ).uiConfig(isFavorite: false),
    onFavoriteTap: {},
    onError: {}
  )
}
