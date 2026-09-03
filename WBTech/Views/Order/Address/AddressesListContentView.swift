//
//  AddressesListContentView.swift
//  WBTech
//
//  Created by sye7qjm3ac on 13.08.2026.
//

import SwiftUI
import UISystem

struct AddressesListContentView: View {
  let selectedAddressID: String?
  let addresses: [Address]
  let canMutate: Bool
  let onAddressPick: (Address) -> Void
  let onAddressEdit: (Address) -> Void
  let onCreateAddress: () -> Void
  let onDismiss: () -> Void
  let onConfirm: () -> Void

  private var isSubmitEnabled: Bool {
    selectedAddressID != nil
  }

  private enum Configuration {
    static let title = "Мои адреса"
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      titleView
        .padding(.horizontal, 15)
      ScrollView {
        listView
          .padding(.horizontal, 15)
      }
    }
    .padding(.top, 18)
    .safeAreaInset(edge: .bottom) {
      bottomBar
    }
  }
  
  private var titleView: some View {
    HStack {
      Text(Configuration.title)
        .font(.dsModalTitle)
        .accessibilityAddTraits(.isHeader)
      Spacer()
      DSDismissButton(action: onDismiss, size: .medium)
    }
  }
  
  private var listView: some View {
    VStack(alignment: .leading, spacing: 8) {
      ForEach(addresses) { address in
        addressRowView(address: address)
      }

      Button(action: {
        onCreateAddress()
      }) {
        HStack(alignment: .center, spacing: 6) {
          Image.dsPlusRounded
            .resizable()
            .frame(width: 16, height: 16)
          Text("Новый адрес")
            .font(.dsAddressPrimary)
        }
        .padding(.top, 8)
      }
      .buttonStyle(DSStaticButtonStyle())
      .disabled(!canMutate)
    }
  }
  
  private var bottomBar: some View {
    Button(action: onConfirm) {
      Text("Привезти сюда")
        .frame(maxWidth: .infinity)
    }
    .buttonStyle(
      DSButtonStyle(
        size: .large,
        style: isSubmitEnabled ? .accent : .accentDisabled
      )
    )
    .disabled(!isSubmitEnabled)
    .padding(.horizontal, 12)
    .padding(.top, 12)
    .padding(.bottom, 12)
    .modifier(DSBottomBarBackgroundViewModifier())
  }

  @ViewBuilder
  private func addressRowView(address: Address) -> some View {
    HStack {
      Button(action: {
        onAddressPick(address)
      }) {
        DSAddressView(
          address: address.uiConfig(),
          withChevron: false,
          style: .list
        )
      }
      Spacer()
      Button(action: {
        onAddressEdit(address)
      }) {
        DSAddressEditButton()
      }
      .disabled(!canMutate)
    }
    .padding(.top, 6)
    .padding(.horizontal, 8)
    .padding(.bottom, 8)
    .background {
      RoundedRectangle(cornerRadius: 8)
        .foregroundStyle(
          LinearGradient.dsProductCard
            .opacity(address.id == selectedAddressID ? 1 : 0)
        )
    }
    .buttonStyle(DSStaticButtonStyle())
  }
}

#Preview {
  AddressesListContentView(
    selectedAddressID: Address.default.id,
    addresses: [Address.default],
    canMutate: true,
    onAddressPick: { print($0.id) },
    onAddressEdit: { print($0.id) },
    onCreateAddress: { },
    onDismiss: { },
    onConfirm: { }
  )
}
