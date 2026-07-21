//

import OSLog
import SwiftUI

struct CatalogView: View {
  let catalogService: CatalogServiceProtocol
  
  @State private var categories: [Category] = []
  @State private var isLoading = true
  
  var body: some View {
    Group {
      switch isLoading {
      case true:
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      case false:
        ScrollView {
          CatalogContentView(categories: categories)
        }
        .scrollIndicators(.hidden)
      }
    }
    .task {
      await loadData()
    }
  }
  
  private func loadData() async {
    isLoading = true
    
    do {
      categories = try await catalogService.fetchCategories()
    } catch {
      Logger.catalog.error("Error loading categories: \(error.localizedDescription)")
    }
    
    isLoading = false
  }
}
