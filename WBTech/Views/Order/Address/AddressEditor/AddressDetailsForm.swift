//
//  AddressDetailsForm.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 19.08.2026.
//

import SwiftUI
import UISystem

struct AddressDetailsForm: View {

  enum Field: Hashable {
    case apartment
    case entrance
    case floor
    case intercomCode
    case comment
  }

  @Binding var draft: AddressDraft
  let isSaveEnabled: Bool
  let isSaving: Bool
  let onSave: () -> Void

  @FocusState private var focusedField: Field?

  init(
    draft: Binding<AddressDraft>,
    isSaveEnabled: Bool = true,
    isSaving: Bool = false,
    onSave: @escaping () -> Void
  ) {
    self._draft = draft
    self.isSaveEnabled = isSaveEnabled
    self.isSaving = isSaving
    self.onSave = onSave
  }

  private enum Layout {
    static let horizontalPadding: CGFloat = 12
    static let topPadding: CGFloat = 24
    static let contentBottomPadding: CGFloat = 24
    static let sectionSpacing: CGFloat = 24
    static let fieldSpacing: CGFloat = 24
    static let buttonVerticalPadding: CGFloat = 12
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(draft.addressLine)
        .font(.dsAddressDetailsTitle)
        .lineLimit(2)
        .accessibilityAddTraits(.isHeader)
        .padding(.top, Layout.topPadding)
        .padding(.horizontal, Layout.horizontalPadding)

      ScrollView {
        fieldsView
          .padding(.top, Layout.sectionSpacing)
          .padding(.horizontal, Layout.horizontalPadding)
          .padding(.bottom, Layout.contentBottomPadding)
      }
      .scrollDismissesKeyboard(.interactively)
    }
    .safeAreaInset(edge: .bottom, spacing: 0) {
      saveButton
    }
  }

  private var fieldsView: some View {
    VStack(spacing: Layout.fieldSpacing) {
      UnderlinedAddressField(
        title: "Квартира/офис",
        text: $draft.apartment
      )
      .focused($focusedField, equals: .apartment)
      .submitLabel(.next)
      .onSubmit { focusedField = .entrance }

      UnderlinedAddressField(
        title: "Подъезд",
        text: $draft.entrance
      )
      .focused($focusedField, equals: .entrance)
      .submitLabel(.next)
      .onSubmit { focusedField = .floor }

      UnderlinedAddressField(
        title: "Этаж",
        text: $draft.floor
      )
      .focused($focusedField, equals: .floor)
      .submitLabel(.next)
      .onSubmit { focusedField = .intercomCode }

      UnderlinedAddressField(
        title: "Код домофона",
        text: $draft.intercomCode
      )
      .focused($focusedField, equals: .intercomCode)
      .submitLabel(.next)
      .onSubmit { focusedField = .comment }

      UnderlinedAddressField(
        title: "Комментарий",
        text: $draft.comment
      )
      .focused($focusedField, equals: .comment)
      .submitLabel(.done)
      .onSubmit { focusedField = nil }
    }
  }

  private var saveButton: some View {
    Button(action: onSave) {
      Group {
        if isSaving {
          ProgressView()
            .tint(Color.dsAccentButtonForeground)
        } else {
          Text("Сохранить")
        }
      }
      .frame(maxWidth: .infinity)
    }
    .buttonStyle(
      DSButtonStyle(
        size: .large,
        style: canSave ? .accent : .accentDisabled
      )
    )
    .disabled(!canSave)
    .padding(.horizontal, Layout.horizontalPadding)
    .padding(.vertical, Layout.buttonVerticalPadding)
  }

  private var canSave: Bool {
    isSaveEnabled && !isSaving
  }
}


#Preview {
  @Previewable @State var draft = AddressDraft(
    coordinates: .init(longitude: 37.62381, latitude: 55.73662),
    addressLine: "Новая Басманная ул., 35 ст1",
    apartment: "59",
    entrance: "3",
    floor: "4",
    intercomCode: "15809",
    comment: ""
  )

  @Previewable @State var isPresented = true

  Color.gray.opacity(0.4)
    .ignoresSafeArea()
    .sheet(isPresented: $isPresented) {
      AddressDetailsForm(
        draft: $draft,
        onSave: {  }
      )
    }
}
