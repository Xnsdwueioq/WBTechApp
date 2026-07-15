//

import SwiftUI

struct FavoritesView: View {
  var body: some View {
    // TODO: Реализовать
    ContentUnavailableView(
      "Избранное пусто",
      systemImage: "heart",
      description: Text("Добавляйте товары в избранное, и они появятся здесь")
    )
  }
}
