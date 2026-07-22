//
//  CatalogTabView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/15/26.
//

import SwiftUI

struct CatalogTabView: View {
  let catalogService: CatalogServiceProtocol
  
  @State private var router = CatalogRouter()
  
  var body: some View {
    NavigationStack(path: $router.path) {
      CatalogView(catalogService: catalogService)
        .navigationDestination(for: CategoryRoute.self) { route in
          CategoryProductsView(route: route, service: catalogService)
        }
    }
    .environment(router)
  }
}
