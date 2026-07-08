//
//  Route.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/7/26.
//

import SwiftUI

enum Route {
  case auth
  case catalog
  case profile
  case designSystem
}

protocol RouterProtocol {
  
  func push(_ route: Route)
  func pop()
  func popToRoot()
  
}

@Observable
final class Router: RouterProtocol {
  
  var path = NavigationPath()
  
  func push(_ route: Route) {
    path.append(route)
  }
  
  func pop() {
    path.removeLast()
  }
  
  func popToRoot() {
    path.removeLast(path.count)
  }
  
}
