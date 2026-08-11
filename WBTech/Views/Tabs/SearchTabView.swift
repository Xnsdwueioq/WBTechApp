//
//  SearchTabView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/20/26.
//

import SwiftUI
import UISystem

struct SearchTabView: View {
  let catalogService: CatalogServiceProtocol
  
  @State private var query = ""
  @State private var isSearchPresented: Bool = true
  
  private enum Configuration {
    static let prompt = "Название продукта"
  }
  
  var body: some View {
    NavigationStack {
      SearchView(catalogService: catalogService, query: query)
    }
    .searchable(
      text: $query,
      isPresented: $isSearchPresented,
      prompt: Configuration.prompt
    )
    .searchSuggestions {
      ForEach(SearchSuggestion.suggestionsList) { suggestion in
        DSSuggestionView(text: suggestion.text)
          .searchCompletion(suggestion.text)
      }
      .listRowSeparator(.hidden)
    }
    .task {
      isSearchPresented = true
    }
  }
}


#Preview {
  SearchTabView(catalogService: MockCatalogService())
    .environment(CartStore(cartService: MockCartService()))
    .environment(FavoritesStore(favoritesService: MockFavoritesService()))
    .environment(ModalRouter())
}
