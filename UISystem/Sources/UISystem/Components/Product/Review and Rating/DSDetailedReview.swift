//
//  DSDetailedReview.swift
//  UISystem
//
//  Created by Eyhciurmrn Zmpodackrl on 7/23/26.
//

import SwiftUI

public struct DSDetailedReview: View {
  let author: String
  let createdAt: Date
  let rating: Double
  let content: String
  let images: [URL?]
  
  public init(author: String, createdAt: Date, rating: Double, content: String, images: [URL?]) {
    self.author = author
    self.createdAt = createdAt
    self.rating = rating
    self.content = content
    self.images = images
  }
  
  private enum Configuration {
    static let headerContentSpacing: CGFloat = 12
    static let headerHorizontalSpacing: CGFloat = 6
    static let topPadding: CGFloat = 10
    static let horizontalPadding: CGFloat = 14
    static let bottomPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20
    
    // MARK: Image
    static let imageCornerRadius: CGFloat = 12
    static let imagesSpacing: CGFloat = 4
    static let imageRatio: CGFloat = 1
    static let imageFrameSize: CGFloat = 70
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: Configuration.headerContentSpacing) {
      // MARK: - Header
      HStack(spacing: Configuration.headerHorizontalSpacing) {
        DSRatingComponent(rating: rating, ratingStyle: .onlyStars, ratingSize: .medium)
        Group {
          Text(author)
          Text(createdAt.formatted(date: .abbreviated, time: .omitted))
        }
        .font(.dsReviewAuthor)
        Spacer()
      }
      
      // MARK: - Content
      Text(content)
        .font(.dsReviewContent)
      
      // MARK: - Images
      HStack(spacing: Configuration.imagesSpacing) {
        ForEach(images, id: \.self) { image in
          DSAsyncImage(url: image)
            .aspectRatio(Configuration.imageRatio, contentMode: .fill)
            .frame(
              width: Configuration.imageFrameSize,
              height: Configuration.imageFrameSize
            )
            .clipShape(
              RoundedRectangle(
                cornerRadius: Configuration.imageCornerRadius
              )
            )
      }
      }
    }
    .padding(.top, Configuration.topPadding)
    .padding(.horizontal, Configuration.horizontalPadding)
    .padding(.bottom, Configuration.bottomPadding)
    .background {
      RoundedRectangle(cornerRadius: Configuration.cornerRadius)
        .foregroundStyle(Color.dsStandartButtonBackground)
    }
  }
}

#Preview {
  DSDetailedReview(author: "Author", createdAt: Date(), rating: 4.49, content: "DSDetailedReview DSDetailedReview DSDetailedReviewDSDetailedReviewDSDetailedReview DSDetailedReviewDSDetailedReviewDSDetailedReview DSDetailedReviewDSDetailedReview", images: [
    .init(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/c98d9645-2f32-475e-b804-f6cbde9bdb3a"),
    .init(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLZ8PldWCaqBQ7o6RD_ZNl3VYsZYJnDNKxYOM1HGuN8g&s=10")
  ])
}
