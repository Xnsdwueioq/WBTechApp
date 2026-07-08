import SwiftUI

public struct DSColors {
  public static let primary = Color(hex: "CB11AB") ?? .purple
  public static let background = Color(uiColor: .systemBackground)
  public static let surface = Color(uiColor: .secondarySystemBackground)
  public static let textPrimary = Color.primary
  public static let textSecondary = Color.secondary
  public static let error = Color.red
}

public extension Color {
  init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
    
    self.init(
      red: Double((rgb & 0xFF0000) >> 16) / 255.0,
      green: Double((rgb & 0x00FF00) >> 8) / 255.0,
      blue: Double(rgb & 0x0000FF) / 255.0
    )
  }
}
