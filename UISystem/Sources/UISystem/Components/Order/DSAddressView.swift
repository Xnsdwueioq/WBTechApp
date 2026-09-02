//
//  DSAddressView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/21/26.
//

import SwiftUI

public enum DSAddressStyle {
  case cartInfo
  case list
  
  public var lineFont: Font {
    switch self {
    case .cartInfo: .dsCartInfoPrimary
    case .list: .dsAddressPrimary
    }
  }
  
  public var additionalInfoFont: Font {
    switch self {
    case .cartInfo: .dsCartInfoSecondary
    case .list: .dsAddressSecondary
    }
  }
  
  public var additionalColor: Color {
    switch self {
    case .cartInfo: .dsAddressPrimary
    case .list: .dsAddressSecondary
    }
  }
}

public struct DSAddressView: View {
  public let address: DSAddressConfig?
  public let withChevron: Bool
  public let style: DSAddressStyle
  
  public init(address: DSAddressConfig?, withChevron: Bool, style: DSAddressStyle) {
    self.address = address
    self.withChevron = withChevron
    self.style = style
  }
  
  private enum Configuration {
    static let addressLinesSpacing: CGFloat = 4
    static let addressPlaceholder = "Адрес не выбран"
    static let floorTitle = "этаж"
    static let entranceTitle = "подъезд"
    static let intercomCodeTitle = "код домофона"
    static let componentsSeparator = ", "
  }

  private var additionalInfo: String {
    guard let address else { return "" }

    var components: [String] = []
    if let floor = nonEmpty(address.floor) {
      components.append("\(floor) \(Configuration.floorTitle)")
    }
    if let entrance = nonEmpty(address.entrance) {
      components.append("\(entrance) \(Configuration.entranceTitle)")
    }
    if let intercomCode = nonEmpty(address.intercomCode) {
      components.append("\(Configuration.intercomCodeTitle) \(intercomCode)")
    }

    return components.joined(separator: Configuration.componentsSeparator)
  }

  private func nonEmpty(_ value: String?) -> String? {
    guard let value else { return nil }
    let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedValue.isEmpty ? nil : trimmedValue
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: Configuration.addressLinesSpacing) {
      HStack {
        Text(address?.addressLine ?? Configuration.addressPlaceholder)
        if withChevron {
          Image.dsChevron
        }
      }
      .font(style.lineFont)
      if !additionalInfo.isEmpty {
        Text(additionalInfo)
          .font(style.additionalInfoFont)
          .foregroundStyle(style.additionalColor)
      }
    }
    .accessibilityElement(children: .combine)
  }
}
