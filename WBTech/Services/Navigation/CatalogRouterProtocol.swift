//

protocol CatalogRouterProtocol {
  
  func pushCategory(id: String, title: String, groupTitle: String)
  func pop()
  func popToRoot()
  
}
