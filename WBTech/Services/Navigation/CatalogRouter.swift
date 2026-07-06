//

import SwiftUI

@Observable
final class CatalogRouter: CatalogRouterProtocol {
  
  var path = NavigationPath()
  
  func pushCategory(id: String, title: String, groupTitle: String) {
    let route = CategoryRoute(categoryId: id, categoryTitle: title, groupTitle: groupTitle)
    path.append(route)
  }
  
  func pop() {
    if !path.isEmpty {
      path.removeLast()
    }
  }
  
  func popToRoot() {
    path.removeLast(path.count)
  }
  
}
