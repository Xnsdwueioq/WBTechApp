//
//  ReviewCreatingView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/23/26.
//

import SwiftUI
import UISystem
import OSLog

struct ReviewCreatingView: View {
  let config: DSProductConfig
  let description: String?
  let productId: String
  let catalogService: CatalogServiceProtocol
  let onReviewCreated: () -> Void

  @Environment(\.dismiss) private var dismiss

  @State private var rating = 0
  @State private var comment = ""
  @State private var isSubmitting = false

  private var isSubmitEnabled: Bool {
    rating > 0 && !isSubmitting
  }

  private enum Configuration {
    static let title = "Отзыв о товаре"
    static let ratingSectionTitle = "Оценка"
    static let commentSectionTitle = "Комментарий"
    static let commentPlaceholder = "Впечатления, пожелания, проблемы с удобными пуфиками, большими зеркалами и плотной шторкой."
    static let photoTitle = "5 файлов JPG, PNG, BMP, GIF."
    static let photoSubtitle = "до 10 МБ каждый"
    static let videoTitle = "Видео в формате MOV, MP4."
    static let videoSubtitle = "до 300 МБ"
    static let agreement = "Соглашаюсь с правилами публикации"
    static let submitTitle = "Оставить отзыв"

    static let imageSize: CGFloat = 90
    static let contentSpacing: CGFloat = 24
    static let sectionSpacing: CGFloat = 12
    static let headerSpacing: CGFloat = 16
    static let headerTextSpacing: CGFloat = 8
    static let titleWeightSpacing: CGFloat = 8
    static let mediaSpacing: CGFloat = 16
    static let bottomBarSpacing: CGFloat = 12
    static let descriptionLineLimit = 4
    static let commentLineLimit = 4
    static let commentMaxLineLimit = 8
    static let fieldPadding: CGFloat = 16
    static let fieldCornerRadius: CGFloat = 16
    static let topPadding: CGFloat = 20
    static let horizontalPadding: CGFloat = 12
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Configuration.contentSpacing) {
        titleView
        productHeader
        ratingSection
        commentSection
        mediaSection
      }
      .padding(.top, Configuration.topPadding)
      .padding(.horizontal, Configuration.horizontalPadding)
    }
    .safeAreaInset(edge: .bottom) {
      bottomBar
    }
  }

  private var titleView: some View {
    HStack {
      Text(Configuration.title)
        .font(.dsModalTitle)
        .accessibilityAddTraits(.isHeader)
      Spacer()
      DSDismissButton(action: { dismiss() }, size: .medium)
    }
  }

  private var productHeader: some View {
    HStack(alignment: .top, spacing: Configuration.headerSpacing) {
      DSProductCardImageView(url: config.imageUrl)
        .frame(width: Configuration.imageSize, height: Configuration.imageSize)

      VStack(alignment: .leading, spacing: Configuration.headerTextSpacing) {
        HStack(spacing: Configuration.titleWeightSpacing) {
          Text(config.name)
            .font(.dsReviewProductName)
          Text(config.weight + config.weightSign)
            .font(.dsReviewProductName)
            .foregroundStyle(Color.dsProductWeightColor)
        }
        if let description {
          Text(description)
            .font(.dsReviewProductDescription)
            .lineLimit(Configuration.descriptionLineLimit)
            .truncationMode(.tail)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }

  private var ratingSection: some View {
    VStack(alignment: .leading, spacing: Configuration.sectionSpacing) {
      Text(Configuration.ratingSectionTitle)
        .font(.dsReviewSectionTitle)
      DSRatingPicker(rating: $rating)
    }
  }

  private var commentSection: some View {
    VStack(alignment: .leading, spacing: Configuration.sectionSpacing) {
      Text(Configuration.commentSectionTitle)
        .font(.dsReviewSectionTitle)
      TextField(Configuration.commentPlaceholder, text: $comment, axis: .vertical)
        .font(.dsReviewFieldText)
        .lineLimit(Configuration.commentLineLimit...Configuration.commentMaxLineLimit)
        .padding(Configuration.fieldPadding)
        .background(
          RoundedRectangle(cornerRadius: Configuration.fieldCornerRadius)
            .strokeBorder(Color.dsReviewFieldBorder, lineWidth: 1)
        )
    }
  }

  private var mediaSection: some View {
    VStack(spacing: Configuration.mediaSpacing) {
      DSReviewMediaButton(
        icon: .dsPhotoReview,
        title: Configuration.photoTitle,
        subtitle: Configuration.photoSubtitle,
        action: {}
      )
      DSReviewMediaButton(
        icon: .dsVideoReview,
        title: Configuration.videoTitle,
        subtitle: Configuration.videoSubtitle,
        action: {}
      )
    }
  }

  private var bottomBar: some View {
    VStack(alignment: .leading, spacing: Configuration.bottomBarSpacing) {
      Text(Configuration.agreement)
        .font(.dsReviewAgreement)
        .foregroundStyle(Color.dsReviewSecondaryText)
      Button(action: submit) {
        Text(Configuration.submitTitle)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(DSButtonStyle(size: .large, style: isSubmitEnabled ? .accent : .accentDisabled))
      .disabled(!isSubmitEnabled)
    }
    .padding(.horizontal, Configuration.horizontalPadding)
    .padding(.bottom, Configuration.bottomBarSpacing)
    .background(LinearGradient.dsBottomBarFade, ignoresSafeAreaEdges: .bottom)
  }

  private func submit() {
    Task { await createReview() }
  }

  private func createReview() async {
    isSubmitting = true
    defer { isSubmitting = false }
    do {
      try await catalogService.createReview(productId: productId, rating: rating, content: comment)
      onReviewCreated()
      dismiss()
    } catch {
      Logger.catalog.error("Unable to create review for product id=\(productId): \(error.localizedDescription)")
    }
  }
}

#Preview {
  ReviewCreatingView(
    config: DSProductConfig(
      name: "Бутер с колбасой",
      weight: "100",
      weightSign: " г",
      price: "100",
      priceValue: 100,
      discount: "0",
      priceSign: "₽",
      imageUrl: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/026c8f99-bbe3-40b4-9ef9-3c3759a857ff"),
      rating: 4.5,
      reviewCount: "12",
      reviewCountWord: "отзывов",
      isFavorite: false
    ),
    description: "Белый хлеб: мука пшеничная высшего сорта, вода очищенная, дрожжи хлебопекарные, соль пищевая, сахар, растительное масло.",
    productId: "product1",
    catalogService: MockCatalogService(),
    onReviewCreated: {}
  )
}
