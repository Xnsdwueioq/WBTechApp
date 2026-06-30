//

import Foundation
import OSLog

extension Logger {
  
  private static let subsystem = Bundle.main.bundleIdentifier ?? "ru.t02.WBTech"
  
  static let catalog = Logger(subsystem: subsystem, category: "Catalog")
  
}
