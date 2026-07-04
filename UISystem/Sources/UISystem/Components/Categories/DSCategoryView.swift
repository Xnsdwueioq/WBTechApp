//

import SwiftUI

public struct DSCategoryView: View {
  let title: String
  let url: URL?
  let action: () -> Void
  let onError: ((Error) -> Void)?
  
  public init(title: String, url: URL?, action: @escaping () -> Void, onError: ((Error) -> Void)? = nil) {
    self.title = title
    self.url = url
    self.action = action
    self.onError = onError
  }
  
  private enum Configuration {
    static let imageRatio: CGFloat = 0.87
    static let cornerRadius: CGFloat = 16
    static let textPadding: CGFloat = 8
  }
  
  public var body: some View {
    Button(action: action) {
      ZStack(alignment: .bottomLeading) {
        DSCategoryImageView(url: url, onError: onError)
        
        Text(title)
          .font(.dsCategoryTitle)
          .padding(Configuration.textPadding)
      }
      .aspectRatio(Configuration.imageRatio, contentMode: .fit)
      .clipShape(RoundedRectangle(cornerRadius: Configuration.cornerRadius))
    }
    .buttonStyle(DSStaticButtonStyle())
  }
}



#Preview {
  DSCategoryView(title: "Любимое из детства", url: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/10/bcb87384-87c0-45a3-b4a7-cf66768437e4"), action: { print("Category clicked") })
}
