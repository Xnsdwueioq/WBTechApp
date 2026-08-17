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
  @Binding var pickedAddress: Address?
  let orderService: OrderServiceProtocol
  let onAddressPick: (Address) -> Void
  let onAddressEdit: (Address) -> Void
  let onCreateAddress: () -> Void
  
  @State private var viewState: ViewState<[Address]> = .idle
  
  var body: some View {
    Group {
      switch viewState {
      case .loaded(let addresses):
        AddressesListContentView(
          pickedAddress: pickedAddress,
          addresses: addresses,
          onAddressPick: onAddressPick,
          onAddressEdit: onAddressEdit,
          onCreateAddress: onCreateAddress
        )

      case .loading, .idle:
        AddressesListContentView(
          pickedAddress: pickedAddress,
          addresses: [Address.default],
          onAddressPick: onAddressPick,
          onAddressEdit: onAddressEdit,
          onCreateAddress: onCreateAddress
        )
        .redacted(reason: .placeholder)
        .allowsHitTesting(false)

      case .error(let errorDescription):
        ContentUnavailableView(errorDescription, image: "xmark")
        // TODO: insert error handling
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
  AddressesListView(pickedAddress: .constant(Address.default), orderService: MockOrderService(), onAddressPick: { _ in print("") }, onAddressEdit: { _ in print("")}, onCreateAddress: {})
}
