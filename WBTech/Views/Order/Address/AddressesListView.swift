//
//  AddressesListView.swift
//  WBTech
//
//  Created by sye7qjm3ac on 13.08.2026.
//

import SwiftUI
import UISystem
import OSLog

struct AddressesListView: View {

  private enum Editor: Identifiable {
    case create
    case details(Address)

    var id: String {
      switch self {
      case .create:
        "create"
      case .details(let address):
        address.id
      }
    }
  }

  @Binding var pickedAddress: Address?
  let orderService: OrderServiceProtocol
  let addressSearchService: AddressSearchServiceProtocol
  let onAddressPick: (Address) -> Void
  
  @State private var viewState: ViewState<[Address]> = .idle
  @State private var editor: Editor?
  
  var body: some View {
    Group {
      switch viewState {
      case .loaded(let addresses):
        AddressesListContentView(
          pickedAddress: pickedAddress,
          addresses: addresses,
          onAddressPick: onAddressPick,
          onAddressEdit: { editor = .details($0) },
          onCreateAddress: { editor = .create }
        )

      case .loading, .idle:
        AddressesListContentView(
          pickedAddress: pickedAddress,
          addresses: [Address.default],
          onAddressPick: onAddressPick,
          onAddressEdit: { _ in },
          onCreateAddress: { }
        )
        .redacted(reason: .placeholder)
        .allowsHitTesting(false)

      case .error(let errorDescription):
        ContentUnavailableView(errorDescription, image: "xmark")
        // TODO: insert error handling
      }
    }
    .sheet(item: $editor) { editor in
      switch editor {
      case .create:
        AddressEditorView(
          addressSearchService: addressSearchService,
          onSave: { _ in } // TODO: insert onSave action
        )

      case .details(let address):
        AddressDetailsEditorView(
          address: address,
          onSave: { _ in } // TODO: insert onSave action
        )
      }
    }
    .task {
      await loadAddresses()
    }
  }
  
  func loadAddresses() async {
    do {
      viewState = .loading
      let addresses = try await orderService.fetchAddresses()
      viewState = .loaded(addresses)
    } catch {
      viewState = .error(error.localizedDescription)
      Logger.order.error("Unable to load user's addresses: \(error.localizedDescription)")
    }
  }
}

#Preview {
  AddressesListView(
    pickedAddress: .constant(Address.default),
    orderService: MockOrderService(),
    addressSearchService: MockAddressSearchService(),
    onAddressPick: { _ in }
  )
}
