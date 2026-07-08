//

import SwiftUI

public struct DSCategoriesGroupTitle: View {
  let title: String
  
  public init(title: String) {
    self.title = title
  }
  
  public var body: some View {
    HStack {
      Text(title)
        .font(.dsCatalogGroupTitle)
      Spacer()
    }
  }
}
