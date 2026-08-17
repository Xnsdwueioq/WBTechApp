//
//  Address+UI.swift
//  WBTech
//
//  Created by sye7qjm3ac on 13.08.2026.
//

import UISystem

extension Address {
  
  func uiConfig() -> DSAddressConfig {
    return .init(
      addressLine: self.addressLine,
      floor: self.floor,
      entrance: self.entrance,
      intercomCode: self.intercomCode,
      comment: self.comment
    )
  }
  
  static func uiConfigDefault() -> DSAddressConfig {
    return .init(
      addressLine: "Новая Басманная ул., 35 ст1, 59",
      floor: "3",
      entrance: "4",
      intercomCode: "15809",
      comment: "Какой-то комментарий"
    )
  }
  
}
