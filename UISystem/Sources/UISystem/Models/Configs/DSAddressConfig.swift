//
//  DSAddressConfig.swift
//  UISystem
//
//  Created by sye7qjm3ac on 13.08.2026.
//

public struct DSAddressConfig {
  public let addressLine: String
  public let floor: String?
  public let entrance: String?
  public let intercomCode: String?
  public let comment: String?
  
  public init(addressLine: String, floor: String?, entrance: String?, intercomCode: String?, comment: String?) {
    self.addressLine = addressLine
    self.floor = floor
    self.entrance = entrance
    self.intercomCode = intercomCode
    self.comment = comment
  }
}
