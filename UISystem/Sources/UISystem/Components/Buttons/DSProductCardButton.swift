//

import SwiftUI

struct DSProductCardButton: View {
  // TODO
//  let action: () -> Void
  let title: String
  
  var body: some View {
    // TODO:
    Button(action: {}, label: {
      Text(title)
    })
    .buttonStyle(DSButtonStyle(size: .small, style: .productCardVariant))
  }
}
