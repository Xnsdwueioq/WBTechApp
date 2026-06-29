//

import SwiftUI

struct CatalogContentView: View {
  let categories: [Category]
  
  enum Configuration {
    static let topPadding: CGFloat = 20
    static let horizontalPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 12
  }
  
  var body: some View {
    VStack {
      CategoriesGroup(title: "От Даркстора", categories: categories)
    }
    .padding(.top, Configuration.topPadding)
    .padding(.horizontal, Configuration.horizontalPadding)
    .padding(.bottom, Configuration.bottomPadding)
  }
}
