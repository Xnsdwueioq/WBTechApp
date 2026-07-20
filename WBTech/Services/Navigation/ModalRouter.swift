// ModalRouter.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 17.07.2026.

import SwiftUI

enum SheetRoute: Identifiable, Hashable, Equatable {
  case productDetailed(product: Product)
  case cart

  var id: String {
    switch self {
    case .productDetailed(let product): product.id
    case .cart: "cart"
    }
  }
}

@Observable
final class ModalRouter: ModalRouterProtocol {
  
  var sheet: SheetRoute?

  func present(route: SheetRoute) {
    sheet = route
  }

  func dismiss() {
    sheet = nil
  }

}



