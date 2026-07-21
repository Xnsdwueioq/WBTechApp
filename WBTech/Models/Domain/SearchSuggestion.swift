//
//  SearchSuggestion.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/21/26.
//

struct SearchSuggestion: Identifiable {
  var text: String
  var id: String { text }
}

extension SearchSuggestion {
  
  static let suggestionsList: [SearchSuggestion] = [
    .init(text: "Хлеб"),
    .init(text: "Сыр"),
    .init(text: "Молоко"),
    .init(text: "Вода"),
    .init(text: "Омар")
  ]
  
}
