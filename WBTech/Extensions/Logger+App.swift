//

import Foundation
import OSLog

extension Logger {
  
  private static let subsystem = Bundle.main.bundleIdentifier ?? "ru.t02.WBTech"
  
  static let catalog = Logger(subsystem: subsystem, category: "Catalog")
  static let cart = Logger(subsystem: subsystem, category: "Cart")
  static let favorites = Logger(subsystem: subsystem, category: "Favorite")
  static let auth = Logger(subsystem: subsystem, category: "Auth")
  static let search = Logger(subsystem: subsystem, category: "Search")
  
}
