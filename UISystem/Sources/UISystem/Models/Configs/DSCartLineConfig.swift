// DSCartLineConfig.swift
// UISystem
// Created by Eyhciurmrn Zmpodackrl on 19.07.2026.

import Foundation

public struct DSCartLineConfig {
  public let name: String
  public let weight: String
  public let weightSign: String
  public let price: String
  public let priceValue: Int
  public let priceSign: String
  public let isAvailable: Bool
  public let imageUrl: URL?
  
  public init(name: String, weight: String, weightSign: String, price: String, priceValue: Int, priceSign: String, isAvailable: Bool, imageUrl: URL?) {
    self.name = name
    self.weight = weight
    self.weightSign = weightSign
    self.price = price
    self.priceValue = priceValue
    self.priceSign = priceSign
    self.isAvailable = isAvailable
    self.imageUrl = imageUrl
  }
}
