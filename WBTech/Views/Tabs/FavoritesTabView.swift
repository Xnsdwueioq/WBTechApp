//
//  FavoritesTabView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/15/26.
//

import SwiftUI

struct FavoritesTabView: View {
  let catalogService: CatalogServiceProtocol
  
  var body: some View {
    NavigationStack {
      FavoritesView(catalogService: catalogService)
    }
  }
}
