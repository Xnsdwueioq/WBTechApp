// ProductDetailedContentView.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 17.07.2026.

import SwiftUI
import UISystem

struct ProductDetailedContentView: View {
  let config: DSProductConfig
  let description: String?
  let reviews: [Review]?
  let quantity: Int
  let onIncrement: () -> Void
  let onDecrement: () -> Void
  let onFavoriteTap: () -> Void
  let onOpenCart: () -> Void
  let onReviews: () -> Void
  let onError: (() -> Void)?
  
  @Environment(\.dismiss) private var dismiss
  
  private enum Configuration {
    static let imageContentSpacing: CGFloat = 0
    static let dismissButtonPaddings: CGFloat = 20
    static let contentSectionsSpacing: CGFloat = 16
    static let contentTopPadding: CGFloat = 20
    static let contentHorizontalPadding: CGFloat = 12
    static let contentBottomPadding: CGFloat = 0
    static let buttonHorizontalPadding: CGFloat = Configuration.contentHorizontalPadding
    static let buttonTopPadding: CGFloat = 12
    static let buttonBottomPadding: CGFloat = 16
  }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Configuration.imageContentSpacing) {
        ZStack {
          ProductDetailedImage(image: config.imageUrl, onError: onError)
          VStack {
            HStack {
              Spacer()
              DSDismissButton(action: { dismiss() }, size: .medium)
                .padding(Configuration.dismissButtonPaddings)
            }
            Spacer()
          }
        }
        VStack(alignment: .leading, spacing: Configuration.contentSectionsSpacing) {
          ProductDetailedHeaderView(config: config, onFavoriteTap: onFavoriteTap, onReviews: onReviews)
          ProductDetailedBody(description: description)
        }
        .padding(.top, Configuration.contentTopPadding)
        .padding(.horizontal, Configuration.contentHorizontalPadding)
        .padding(.bottom, Configuration.contentBottomPadding)
      }
    }
    .safeAreaInset(edge: .bottom) {
      DSProductDetailedButton(
        quantity: quantity,
        priceValue: config.priceValue,
        priceSign: config.priceSign,
        onIncrement: onIncrement,
        onDecrement: onDecrement,
        onOpenCart: onOpenCart
      )
      .padding(.horizontal, Configuration.buttonHorizontalPadding)
      .padding(.top, Configuration.buttonTopPadding)
      .padding(.bottom, Configuration.buttonBottomPadding)
      .background(LinearGradient.dsBottomBarFade, ignoresSafeAreaEdges: .bottom)
    }
  }
}
