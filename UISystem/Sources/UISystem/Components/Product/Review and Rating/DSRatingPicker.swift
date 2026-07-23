//

import SwiftUI

public struct DSRatingPicker: View {
  @Binding var rating: Int

  public init(rating: Binding<Int>) {
    self._rating = rating
  }

  private enum Layout {
    static let maxStars = 5
    static let spacing: CGFloat = 12
    static let starSize: CGFloat = 44
  }

  public var body: some View {
    HStack(spacing: Layout.spacing) {
      ForEach(1...Layout.maxStars, id: \.self) { grade in
        Button {
          rating = grade
        } label: {
          Image.dsReviewStar
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: Layout.starSize, height: Layout.starSize)
            .foregroundStyle(grade <= rating ? Color.dsReviewStarActive : Color.dsReviewStarIdle)
        }
        .buttonStyle(DSStaticButtonStyle())
        .accessibilityLabel("Поставить оценку \(grade)")
      }
    }
  }
}

#Preview {
  @Previewable @State var rating = 3
  DSRatingPicker(rating: $rating)
    .padding()
}
