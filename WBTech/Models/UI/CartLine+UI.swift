// CartLine+UI.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 19.07.2026.

import Foundation
import UISystem

extension CartLine {
  
  func uiConfig() -> DSCartLineConfig {
    DSCartLineConfig(
      name: self.name,
      weight: String(self.weight),
      weightSign: "г",
      price: "\(self.price)",
      priceValue: self.price,
      priceSign: "₽",
      isAvailable: self.available,
      imageUrl: URL(string: self.image)
    )
  }
  
}
