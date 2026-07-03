//

import SwiftUI

struct DSProductCardButton: View {
  let action: () -> Void
  let title: String
  
  var body: some View {
    Button(action: action, label: {
      Text(title)
    })
    .buttonStyle(DSButtonStyle(size: .small, style: .productCardVariant))
  }
}

#Preview {
  DSProductCardButton(action: {}, title: "В корзину")
}
