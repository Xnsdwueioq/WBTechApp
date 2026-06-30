//

import OSLog
import SwiftUI

struct CatalogView: View {
  let catalogService: CatalogServiceProtocol
  
  @State private var categories: [Category] = []
  @State private var isLoading = true
  
  var body: some View {
    ScrollView {
      switch isLoading {
      case true:
        ProgressView()
      case false:
        CatalogContentView(categories: categories)
      }
    }
    .scrollIndicators(.hidden)
    .task {
      await loadData()
    }
  }
  
  private func loadData() async {
    isLoading = true
    
    do {
      categories = try await catalogService.fetchCategories()
    } catch {
      Logger.catalog.error("Ошибка загрузки категорий: \(error.localizedDescription)")
    }
    
    isLoading = false
  }
}

#Preview {
  CatalogView(catalogService: MockCatalogService())
}
