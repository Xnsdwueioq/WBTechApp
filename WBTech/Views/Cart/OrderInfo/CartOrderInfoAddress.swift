//
//  CartOrderInfoAddress.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/21/26.
//

import SwiftUI
import UISystem

struct CartOrderInfoAddress: View {
  let address: Address?
  
  private enum Configuration {
    static let addressLinesSpacing: CGFloat = 0
    static let addressPlaceholder = "Адрес не выбран"
    static let floorTitle = "этаж"
    static let entranceTitle = "подъезд"
    static let intercomCodeTitle = "код домофона"
    static let componentsSeparator = ", "
  }

  private var additionalInfo: String {
    guard let address else { return "" }

    var components: [String] = []
    if let floor = address.floor {
      components.append("\(floor) \(Configuration.floorTitle)")
    }
    if let entrance = address.entrance {
      components.append("\(entrance) \(Configuration.entranceTitle)")
    }
    if let intercomCode = address.intercomCode {
      components.append("\(Configuration.intercomCodeTitle) \(intercomCode)")
    }

    return components.joined(separator: Configuration.componentsSeparator)
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Configuration.addressLinesSpacing) {
      HStack {
        Text(address?.addressLine ?? Configuration.addressPlaceholder)
        Image.dsChevron
      }
      .font(.dsCartInfoPrimary)
      if !additionalInfo.isEmpty {
        Text(additionalInfo)
      }
    }
    .accessibilityElement(children: .combine)
    .accessibilityHint("Открывает выбор адреса")
  }
}
