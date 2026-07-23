//

import SwiftUI

public struct DSFavoriteButton: View {
  let isActive: Bool
  let sizeType: DSFavoriteButtonSize
  let onFavoriteTap: () -> Void
  
  public init(isActive: Bool, sizeType: DSFavoriteButtonSize, onFavoriteTap: @escaping () -> Void) {
    self.isActive = isActive
    self.sizeType = sizeType
    self.onFavoriteTap = onFavoriteTap
  }
  
  public var body: some View {
    let image: Image = isActive ? .dsActiveFavorite : .dsIdleFavorite
    
    Button(action: onFavoriteTap) {
      image
        .resizable()
        .scaledToFit()
        .frame(width: sizeType.size)
        .contentShape(Rectangle())
    }
    .accessibilityLabel(isActive ? "Убрать из избранного" : "Добавить в избранное")
    .accessibilityAddTraits(isActive ? [.isSelected] : [])
  }
}


public enum DSFavoriteButtonSize {
  case small
  case medium
  
  var size: CGFloat {
    switch self {
    case .small: return 32
    case .medium: return 40
    }
  }
}
