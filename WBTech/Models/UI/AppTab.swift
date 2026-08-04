//

import Foundation

enum AppTab: String, CaseIterable, Identifiable {
  case catalog = "Каталог"
  case search = "Поиск"
  case favourites = "Избранное"
  case cart = "Корзина"
  
  var id: String {
    return self.rawValue
  }
}
