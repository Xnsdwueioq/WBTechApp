//
//  DSSuggestionToSearchView.swift
//  UISystem
//
//  Created by sye7qjm3ac on 12.08.2026.
//

import SwiftUI

public struct DSSuggestionToSearchView: View {
  public init() { }
  
  public var body: some View {
    ContentUnavailableView(
      "Начните поиск",
      systemImage: "sparkle.magnifyingglass",
      description: Text("Найдите нужный Вам продукт из широкого ассортимента")
    )
  }
}

#Preview {
  DSSuggestionToSearchView()
}
