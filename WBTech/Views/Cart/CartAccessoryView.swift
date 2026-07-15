//

import SwiftUI

struct CartAccessoryView: View {
  @Environment(CartStore.self) private var cartStore

  private var totalItems: Int {
    cartStore.quantities.values.reduce(0, +)
  }

  var body: some View {
    if totalItems > 0 {
      Button {
        // TODO: открыть экран корзины (следующий шаг)
      } label: {
        HStack(spacing: 12) {
          Text("\(totalItems) \(Self.itemsWord(for: totalItems))")
            .font(.subheadline.weight(.medium))
          Spacer(minLength: 0)
          Text("Оформить")
            .font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal, 16)
        .contentShape(.rect)
      }
      .buttonStyle(.plain)
      .accessibilityLabel("Корзина, \(totalItems) \(Self.itemsWord(for: totalItems)). Оформить заказ")
    }
  }

  private static func itemsWord(for count: Int) -> String {
    let mod10 = count % 10
    let mod100 = count % 100
    if mod10 == 1 && mod100 != 11 { return "товар" }
    if (2...4).contains(mod10) && !(12...14).contains(mod100) { return "товара" }
    return "товаров"
  }
}
