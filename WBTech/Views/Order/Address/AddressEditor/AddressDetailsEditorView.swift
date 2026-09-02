//
//  AddressDetailsEditorView.swift
//  WBTech
//

import SwiftUI

struct AddressDetailsEditorView: View {

  @Environment(\.dismiss) private var dismiss

  private let onSave: (AddressDraft) -> Void

  @State private var draft: AddressDraft

  init(
    address: Address,
    onSave: @escaping (AddressDraft) -> Void
  ) {
    self.onSave = onSave
    self.draft = AddressDraft(address: address)
  }

  var body: some View {
    AddressDetailsForm(
      draft: $draft,
      isSaveEnabled: draft.isValid,
      onSave: save
    )
  }

  private func save() {
    onSave(draft)
    dismiss()
  }
}

#Preview {
  AddressDetailsEditorView(
    address: .default,
    onSave: { _ in }
  )
}
