import SwiftUI
import UISystem

struct AddressesListView: View {

  private enum Editor: Identifiable {
    case create
    case details(Address)

    var id: String {
      switch self {
      case .create: "create"
      case .details(let address): address.id
      }
    }
  }

  @Environment(\.dismiss) private var dismiss
  @Environment(AddressStore.self) private var store

  let addressSearchService: AddressSearchServiceProtocol

  @State private var draftSelectedID: String?
  @State private var editor: Editor?

  var body: some View {
    content
      .sheet(item: $editor) { editor in
        switch editor {
        case .create:
          AddressEditorView(
            addressSearchService: addressSearchService,
            onSave: createAddress
          )

        case .details(let address):
          AddressDetailsEditorView(
            address: address,
            onSave: { draft in
              try await store.updateAddress(id: address.id, draft: draft)
            },
            onDelete: {
              try await store.deleteAddress(id: address.id)
              if draftSelectedID == address.id {
                draftSelectedID = store.selectedAddressID
              }
            }
          )
        }
      }
      .onAppear {
        if draftSelectedID == nil {
          draftSelectedID = store.selectedAddressID
        }
      }
      .onChange(of: store.addresses) { _, addresses in
        guard let draftSelectedID,
              addresses.contains(where: { $0.id == draftSelectedID }) else {
          self.draftSelectedID = store.selectedAddressID
          return
        }
      }
      .alert(item: errorBinding) { error in
        Alert(
          title: Text(error.title),
          message: Text(error.message),
          dismissButton: .default(Text("OK")) { store.dismissError() }
        )
      }
  }

  @ViewBuilder
  private var content: some View {
    switch store.loadState {
    case .idle where store.addresses.isEmpty,
         .loading where store.addresses.isEmpty:
      placeholder

    case .failed where store.addresses.isEmpty:
      ContentUnavailableView {
        Label("Адреса недоступны", systemImage: "wifi.exclamationmark")
      } description: {
        Text("Не удалось загрузить список адресов.")
      } actions: {
        Button("Повторить") { Task { await store.reload() } }
      }

    default:
      AddressesListContentView(
        selectedAddressID: draftSelectedID,
        addresses: store.addresses,
        canMutate: store.canMutate,
        onAddressPick: { draftSelectedID = $0.id },
        onAddressEdit: { editor = .details($0) },
        onCreateAddress: { editor = .create },
        onDismiss: { dismiss() },
        onConfirm: confirmSelection
      )
    }
  }

  private var placeholder: some View {
    AddressesListContentView(
      selectedAddressID: Address.default.id,
      addresses: [.default],
      canMutate: false,
      onAddressPick: { _ in },
      onAddressEdit: { _ in },
      onCreateAddress: { },
      onDismiss: { },
      onConfirm: { }
    )
    .redacted(reason: .placeholder)
    .allowsHitTesting(false)
  }

  private var errorBinding: Binding<AddressUserError?> {
    Binding(
      get: { store.userError },
      set: { if $0 == nil { store.dismissError() } }
    )
  }

  private func createAddress(_ draft: AddressDraft) async throws {
    if let newAddressID = try await store.createAddress(draft) {
      draftSelectedID = newAddressID
    }
  }

  private func confirmSelection() {
    guard let draftSelectedID else { return }
    store.confirmSelection(id: draftSelectedID)
    dismiss()
  }
}

#Preview {
  AddressesListView(addressSearchService: MockAddressSearchService())
    .environment(
      AddressStore(
        addresses: [.default],
        selectedAddressID: Address.default.id,
        orderService: MockOrderService()
      )
    )
}
