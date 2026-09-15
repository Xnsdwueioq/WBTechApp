//
//  AddressSearchForm.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 30.08.2026.
//

import SwiftUI
import UISystem
import OSLog

struct AddressSearchState {
  var cityText = ""
  var streetText = ""
  var house = ""
  var building = ""

  var selectedCity: AddressSearchCity?
  var selectedStreet: AddressSearchSuggestion?
  var citySuggestions: [AddressSearchSuggestion] = []
  var streetSuggestions: [AddressSearchSuggestion] = []

  var citySuggestionsError: String?
  var streetSuggestionsError: String?
  var resolutionError: String?
  var isResolvingCity = false
  var isResolvingAddress = false

  var canResolveAddress: Bool {
    selectedCity != nil
      && selectedStreet != nil
      && !house.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && !isResolvingAddress
  }

  var canEditStreet: Bool {
    selectedCity != nil
      || !cityText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  var canEditAddressDetails: Bool {
    selectedStreet != nil
      || (selectedCity != nil
        && !streetText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
  }

  mutating func updateCityText(_ value: String) {
    cityText = value
    selectedCity = nil
    selectedStreet = nil
    streetText = ""
    house = ""
    building = ""
    citySuggestions = []
    streetSuggestions = []
    citySuggestionsError = nil
    streetSuggestionsError = nil
  }

  mutating func updateStreetText(_ value: String) {
    streetText = value
    selectedStreet = nil
    house = ""
    building = ""
    streetSuggestions = []
    streetSuggestionsError = nil
  }
}

struct AddressSearchForm: View {

  enum Field: Hashable {
    case city
    case street
    case house
    case building
  }

  private enum Configuration {
    static let horizontalPadding: CGFloat = 12
    static let topPadding: CGFloat = 28
    static let fieldSpacing: CGFloat = 24
    static let suggestionVerticalPadding: CGFloat = 10
    static let buttonVerticalPadding: CGFloat = 12
  }

  private struct StreetSearchKey: Hashable {
    let cityID: String?
    let query: String
  }

  let initialCoordinates: AddressCoordinates
  let addressSearchService: AddressSearchServiceProtocol
  let onSelect: (AddressSearchSelection) -> Void

  @State var state = AddressSearchState()
  @FocusState var focusedField: Field?

  var body: some View {
    ScrollView {
      VStack(spacing: Configuration.fieldSpacing) {
        citySection
        streetSection

        UnderlinedAddressField(
          title: "Дом",
          text: $state.house
        )
        .focused($focusedField, equals: .house)
        .submitLabel(.next)
        .disabled(!state.canEditAddressDetails)
        .onSubmit { focusedField = .building }

        UnderlinedAddressField(
          title: "Корпус/строение",
          text: $state.building
        )
        .focused($focusedField, equals: .building)
        .submitLabel(.done)
        .disabled(!state.canEditAddressDetails)
        .onSubmit {
          focusedField = nil
          guard state.canResolveAddress else { return }
          Task { await showAddressOnMap() }
        }
      }
      .padding(.top, Configuration.topPadding)
      .padding(.horizontal, Configuration.horizontalPadding)
      .padding(.bottom, Configuration.fieldSpacing)
    }
    .scrollDismissesKeyboard(.interactively)
    .safeAreaInset(edge: .bottom, spacing: 0) {
      showOnMapButton
    }
    .task {
      await loadInitialCity()
    }
    .task(id: state.cityText) {
      await loadCitySuggestions(for: state.cityText)
    }
    .task(
      id: StreetSearchKey(
        cityID: state.selectedCity?.id,
        query: state.streetText
      )
    ) {
      await loadStreetSuggestions(for: state.streetText)
    }
    .onChange(of: focusedField) { oldField, newField in
      if oldField == .city,
         newField != .city,
         state.selectedCity == nil {
        Task { await submitCity() }
      }

      if oldField == .street,
         newField != .street,
         state.selectedStreet == nil {
        submitStreet()
      }
    }
    .alert(
      "Не удалось найти адрес",
      isPresented: Binding(
        get: { state.resolutionError != nil },
        set: { if !$0 { state.resolutionError = nil } }
      )
    ) {
      Button("Повторить") {
        Task { await showAddressOnMap() }
      }
      Button("Отмена", role: .cancel) { }
    } message: {
      Text(state.resolutionError ?? "Попробуйте ещё раз")
    }
  }

  private var citySection: some View {
    VStack(alignment: .leading, spacing: 0) {
      searchField(
        title: "Город",
        text: cityBinding,
        field: .city,
        isEnabled: true
      )

      if state.selectedCity == nil {
        suggestionError(state.citySuggestionsError)
        suggestionsList(state.citySuggestions, showsSubtitle: true) { suggestion in
          Task { await selectCity(suggestion) }
        }
      }
    }
  }

  private var streetSection: some View {
    VStack(alignment: .leading, spacing: 0) {
      searchField(
        title: "Улица",
        text: streetBinding,
        field: .street,
        isEnabled: state.canEditStreet
      )

      if state.selectedCity != nil, state.selectedStreet == nil {
        suggestionError(state.streetSuggestionsError)
        suggestionsList(state.streetSuggestions, showsSubtitle: false) { suggestion in
          selectStreet(suggestion)
        }
      }
    }
  }

  private var showOnMapButton: some View {
    Button {
      Task { await showAddressOnMap() }
    } label: {
      Group {
        if state.isResolvingAddress {
          ProgressView()
            .tint(Color.dsAccentButtonForeground)
        } else {
          Text("Показать на карте")
        }
      }
      .frame(maxWidth: .infinity)
    }
    .buttonStyle(
      DSButtonStyle(
        size: .large,
        style: state.canResolveAddress ? .accent : .accentDisabled
      )
    )
    .disabled(!state.canResolveAddress)
    .padding(.horizontal, Configuration.horizontalPadding)
    .padding(.vertical, Configuration.buttonVerticalPadding)
  }

  private var cityBinding: Binding<String> {
    Binding(
      get: { state.cityText },
      set: { state.updateCityText($0) }
    )
  }

  private var streetBinding: Binding<String> {
    Binding(
      get: { state.streetText },
      set: { state.updateStreetText($0) }
    )
  }

  private func searchField(
    title: String,
    text: Binding<String>,
    field: Field,
    isEnabled: Bool
  ) -> some View {
    UnderlinedAddressField(
      title: title,
      text: text
    )
    .focused($focusedField, equals: field)
    .submitLabel(.next)
    .disabled(!isEnabled)
    .overlay(alignment: .trailing) {
      if !text.wrappedValue.isEmpty && isEnabled {
        Button {
          text.wrappedValue = ""
        } label: {
          Image.dsXmark
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(Color.dsAddressDetailsFieldLabel)
            .frame(width: 32, height: 32)
        }
        .accessibilityLabel("Очистить \(title.lowercased())")
        .padding(.bottom, 1)
      }
    }
    .onSubmit {
      switch field {
      case .city:
        Task { await submitCity() }
      case .street:
        submitStreet()
      case .house, .building:
        break
      }
    }
  }

  @ViewBuilder
  private func suggestionsList(
    _ suggestions: [AddressSearchSuggestion],
    showsSubtitle: Bool,
    onSelect: @escaping (AddressSearchSuggestion) -> Void
  ) -> some View {
    if !suggestions.isEmpty {
      LazyVStack(alignment: .leading, spacing: 0) {
        ForEach(suggestions) { suggestion in
          Button {
            onSelect(suggestion)
          } label: {
            VStack(alignment: .leading, spacing: 2) {
              Text(suggestion.title)
                .font(.dsAddressDetailsFieldValue)
                .foregroundStyle(Color.dsSearchSuggestion)

              if showsSubtitle && !suggestion.subtitle.isEmpty {
                Text(suggestion.subtitle)
                  .font(.dsAddressDetailsFieldLabel)
                  .foregroundStyle(Color.dsAddressDetailsFieldLabel)
              }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, Configuration.suggestionVerticalPadding)
          }
          .buttonStyle(.plain)
          .disabled(state.isResolvingCity)
        }
      }
    }
  }

  @ViewBuilder
  private func suggestionError(_ message: String?) -> some View {
    if let message {
      Text(message)
        .font(.dsAddressDetailsFieldLabel)
        .foregroundStyle(Color.dsAddressDetailsFieldLabel)
        .padding(.top, 8)
    }
  }

  static let searchLocale = Locale(identifier: "ru_RU")
}

#Preview {
  @Previewable @State var isPresented = true

  Color.gray.opacity(0.4)
    .ignoresSafeArea()
    .sheet(isPresented: $isPresented) {
      AddressSearchForm(
        initialCoordinates: .init(longitude: 61.4026, latitude: 55.1603),
        addressSearchService: MockAddressSearchService(),
        onSelect: { _ in }
      )
    }
}
