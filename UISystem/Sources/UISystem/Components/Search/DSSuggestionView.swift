//
//  DSSuggestionView.swift
//  UISystem
//
//  Created by Eyhciurmrn Zmpodackrl on 7/21/26.
//

import SwiftUI

public struct DSSuggestionView: View {
  let text: String
  
  public init(text: String) {
    self.text = text
  }
  
  public var body: some View {
    Text(text)
      .font(.dsSearchSuggestion)
      .foregroundStyle(Color.dsSearchSuggestion)
  }
}


#Preview {
  DSSuggestionView(text: "Some text")
}
