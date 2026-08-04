//
// ViewState.swift
// WBTech
//

import Foundation

enum ViewState<T> {
  case idle
  case loading
  case loaded(T)
  case error(String)
}

extension ViewState {
  var isLoading: Bool {
    if case .loading = self { return true }
    return false
  }
  
  var value: T? {
    if case .loaded(let data) = self { return data }
    return nil
  }
  
  var errorMessage: String? {
    if case .error(let message) = self { return message }
    return nil
  }
}
