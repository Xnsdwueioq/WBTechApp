//
//  DSAddressConfig.swift
//  UISystem
//
//  Created by sye7qjm3ac on 13.08.2026.
//

import Foundation

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

  public func additionalInfo(includingComment: Bool = false) -> String? {
    var components: [String] = []

    if let floor = nonEmpty(floor) {
      components.append("\(floor) этаж")
    }
    if let entrance = nonEmpty(entrance) {
      components.append("\(entrance) подъезд")
    }
    if let intercomCode = nonEmpty(intercomCode) {
      components.append("код домофона \(intercomCode)")
    }

    var lines = [components.joined(separator: ", ")].filter { !$0.isEmpty }
    if includingComment, let comment = nonEmpty(comment) {
      lines.append(comment)
    }

    let result = lines.joined(separator: "\n")
    return result.isEmpty ? nil : result
  }

  private func nonEmpty(_ value: String?) -> String? {
    guard let value else { return nil }
    let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
    return normalized.isEmpty ? nil : normalized
  }
}
