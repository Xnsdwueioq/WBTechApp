//
//  DSAddressEditButton.swift
//  UISystem
//
//  Created by sye7qjm3ac on 13.08.2026.
//

import SwiftUI

struct DSAddressEditButton: View {
  
  var body: some View {
    Image.dsPencil
      .foregroundStyle(Color.dsAddressEdit)
      .frame(width: 24)
  }
}

#Preview {
  DSAddressEditButton()
}
