//

import Foundation

enum AppTab: String, CaseIterable, Identifiable {
  case forYou = "Для тебя"
  case catalog = "Каталог"
  case discounts = "Скидки"
  case favourites = "Избранное"
  case alreadyOrdered = "Уже заказывали"
  
  var id: String {
    return self.rawValue
  }
}
