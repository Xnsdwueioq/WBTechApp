// DSDismissButton.swift
// UISystem
// Created by Eyhciurmrn Zmpodackrl on 18.07.2026.

import SwiftUI

public enum DSDismissButtonSize {
  case medium
  
  var frameSize: CGFloat {
    switch self {
    case .medium: return 18
    }
  }
}

public struct DSDismissButton: View {
  let action: () -> Void
  let size: DSDismissButtonSize
  
  public init(action: @escaping () -> Void, size: DSDismissButtonSize) {
    self.action = action
    self.size = size
  }
  
  public var body: some View {
    Button(action: action){
      Image.dsXmark
        .resizable()
        .scaledToFit()
        .frame(width: size.frameSize)
        .foregroundStyle(.gray)
    }
  }
}
