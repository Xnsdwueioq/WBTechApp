//
// CatalogView.swift
// WBTech
//

import OSLog
import SwiftUI
import UISystem

struct CatalogView: View {
  let catalogService: CatalogServiceProtocol
  
  @State private var viewState = ViewState<[Category]>.idle
  
  var body: some View {
    Group {
      switch viewState {
      case .idle, .loading:
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)

      case .loaded(let categories):
        ScrollView {
          CatalogContentView(categories: categories)
        }
        .scrollIndicators(.hidden)

      case .error(let errorMessage):
        DSErrorView(
          description: errorMessage,
          onRetry: { Task { await loadData() } }
        )
      }
    }
    .task {
      await loadData()
    }
  }
  
  private func loadData() async {
    viewState = .loading
    do {
      let categories = try await catalogService.fetchCategories()
      viewState = .loaded(categories)
    } catch {
      Logger.catalog.error("Error loading categories: \(error.localizedDescription)")
      viewState = .error("Не удалось загрузить категории")
    }
  }
}
