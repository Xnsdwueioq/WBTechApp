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
  case orderDetails
  
  public var lineFont: Font {
    switch self {
    case .cartInfo: .dsCartInfoPrimary
    case .list: .dsAddressPrimary
    case .orderDetails: .dsProductCardTitle
    }
  }
  
  public var additionalInfoFont: Font {
    switch self {
    case .cartInfo: .dsCartInfoSecondary
    case .list: .dsAddressSecondary
    case .orderDetails: .dsProductCardTitle
    }
  }
  
  public var additionalColor: Color {
    switch self {
    case .cartInfo: .dsAddressPrimary
    case .list: .dsAddressSecondary
    case .orderDetails: .dsTabFontColor
    }
  }

  var linesSpacing: CGFloat {
    switch self {
    case .cartInfo, .list: 4
    case .orderDetails: 2
    }
  }

  var showsComment: Bool {
    self == .orderDetails
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
    static let addressPlaceholder = "Адрес не выбран"
  }

  private var additionalInfo: String? {
    address?.additionalInfo(includingComment: style.showsComment)
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: style.linesSpacing) {
      HStack {
        Text(address?.addressLine ?? Configuration.addressPlaceholder)
        if withChevron {
          Image.dsChevron
        }
      }
      .font(style.lineFont)
      if let additionalInfo {
        Text(additionalInfo)
          .font(style.additionalInfoFont)
          .foregroundStyle(style.additionalColor)
      }
    }
    .accessibilityElement(children: .combine)
  }
}
