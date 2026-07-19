//

import Foundation

enum AppTab: String, CaseIterable, Identifiable {
  case catalog = "Каталог"
  case favourites = "Избранное"
  case search = "Поиск"
  
  var id: String {
    return self.rawValue
  }
}
