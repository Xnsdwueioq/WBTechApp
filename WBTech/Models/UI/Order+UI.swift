import Foundation
import UISystem

extension Order {

  private enum Configuration {
    static let defaultETAMinutes = 12
    static let russianLocale = Locale(identifier: "ru_RU")
    static let deliveryDateFormat = "d MMMM"
    static let deliveryTimeFormat = "HH:mm"
    static let deliveredFallbackTitle = "Заказ доставлен"
  }

  func statusTitle(etaMinutes: Int = Configuration.defaultETAMinutes) -> String {
    switch status {
    case .active:
      return "Доставим через \(PluralNoun.minute.counted(max(etaMinutes, 0)))"
    case .completed:
      guard
        let deliveryDate,
        let date = try? FlexibleISO8601DateTranscoder().decode(deliveryDate)
      else {
        return Configuration.deliveredFallbackTitle
      }

      let dateFormatter = DateFormatter()
      dateFormatter.locale = Configuration.russianLocale
      dateFormatter.dateFormat = Configuration.deliveryDateFormat

      let timeFormatter = DateFormatter()
      timeFormatter.locale = Configuration.russianLocale
      timeFormatter.dateFormat = Configuration.deliveryTimeFormat

      return "Доставили \(dateFormatter.string(from: date)) в \(timeFormatter.string(from: date))"
    }
  }
}

extension OrderAddress {

  func uiConfig() -> DSAddressConfig {
    DSAddressConfig(
      addressLine: addressLine,
      floor: floor,
      entrance: entrance,
      intercomCode: intercomCode,
      comment: comment
    )
  }
}
