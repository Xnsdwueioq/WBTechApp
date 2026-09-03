import SwiftUI

struct AddressDetailsEditorView: View {

  private enum PresentedAlert: Identifiable {
    case deleteConfirmation
    case error(String)

    var id: String {
      switch self {
      case .deleteConfirmation: "delete"
      case .error(let message): message
      }
    }
  }

  @Environment(\.dismiss) private var dismiss

  private let onSave: (AddressDraft) async throws -> Void
  private let onDelete: () async throws -> Void

  @State private var draft: AddressDraft
  @State private var isWorking = false
  @State private var presentedAlert: PresentedAlert?

  init(
    address: Address,
    onSave: @escaping (AddressDraft) async throws -> Void,
    onDelete: @escaping () async throws -> Void
  ) {
    self.onSave = onSave
    self.onDelete = onDelete
    self.draft = AddressDraft(address: address)
  }

  var body: some View {
    AddressDetailsForm(
      draft: $draft,
      isSaveEnabled: draft.isValid,
      isSaving: isWorking,
      onSave: save,
      onDelete: { presentedAlert = .deleteConfirmation }
    )
    .alert(item: $presentedAlert) { alert in
      switch alert {
      case .deleteConfirmation:
        Alert(
          title: Text("Удалить адрес?"),
          message: Text("Это действие нельзя отменить."),
          primaryButton: .destructive(Text("Удалить"), action: delete),
          secondaryButton: .cancel()
        )
      case .error(let message):
        Alert(
          title: Text("Не удалось выполнить действие"),
          message: Text(message),
          dismissButton: .default(Text("OK"))
        )
      }
    }
  }

  private func save() {
    perform { try await onSave(draft) }
  }

  private func delete() {
    perform(operation: onDelete)
  }

  private func perform(
    operation: @escaping () async throws -> Void
  ) {
    guard !isWorking else { return }
    isWorking = true

    Task {
      defer { isWorking = false }
      do {
        try await operation()
        dismiss()
      } catch {
        presentedAlert = .error(error.localizedDescription)
      }
    }
  }
}

#Preview {
  AddressDetailsEditorView(
    address: .default,
    onSave: { _ in },
    onDelete: { }
  )
}
