//
//  AddressSearchForm.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 30.08.2026.
//

import SwiftUI
import UISystem
import OSLog

private struct AddressSearchState {
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

  private enum Field: Hashable {
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

  @State private var state = AddressSearchState()
  @FocusState private var focusedField: Field?

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
        Button(action: { text.wrappedValue = "" }) {
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
          Button(action: { onSelect(suggestion) }) {
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

  private func loadInitialCity() async {
    do {
      if let city = try await addressSearchService.city(
        at: initialCoordinates,
        locale: Self.searchLocale
      ) {
        guard state.cityText.isEmpty, state.selectedCity == nil else { return }
        state.selectedCity = city
        state.cityText = city.name
        focusedField = .street
      } else {
        focusedField = .city
      }
    } catch {
      Logger.map.error("Unable to resolve the initial city: \(error.localizedDescription)")
      focusedField = .city
    }
  }

  private func loadCitySuggestions(for query: String) async {
    let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard state.selectedCity == nil, !query.isEmpty else {
      state.citySuggestions = []
      state.citySuggestionsError = nil
      return
    }

    do {
      state.citySuggestions = []
      state.citySuggestionsError = nil
      let suggestions = try await addressSearchService.citySuggestions(for: query)
      guard !Task.isCancelled,
            state.selectedCity == nil,
            state.cityText.trimmingCharacters(in: .whitespacesAndNewlines) == query else { return }
      state.citySuggestions = suggestions
      state.citySuggestionsError = nil
    } catch is CancellationError {
      return
    } catch {
      guard state.cityText.trimmingCharacters(in: .whitespacesAndNewlines) == query else { return }
      state.citySuggestions = []
      state.citySuggestionsError = "Не удалось загрузить города"
      Logger.map.error("City suggestions failed: \(error.localizedDescription)")
    }
  }

  private func loadStreetSuggestions(for query: String) async {
    let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let city = state.selectedCity,
          state.selectedStreet == nil,
          !query.isEmpty else {
      state.streetSuggestions = []
      state.streetSuggestionsError = nil
      return
    }

    do {
      state.streetSuggestions = []
      state.streetSuggestionsError = nil
      let suggestions = try await addressSearchService.streetSuggestions(
        for: query,
        city: city
      )
      guard !Task.isCancelled,
            state.selectedCity?.id == city.id,
            state.selectedStreet == nil,
            state.streetText.trimmingCharacters(in: .whitespacesAndNewlines) == query else { return }
      state.streetSuggestions = suggestions
      state.streetSuggestionsError = nil
    } catch is CancellationError {
      return
    } catch {
      guard state.selectedCity?.id == city.id,
            state.streetText.trimmingCharacters(in: .whitespacesAndNewlines) == query else { return }
      state.streetSuggestions = []
      state.streetSuggestionsError = "Не удалось загрузить улицы"
      Logger.map.error("Street suggestions failed: \(error.localizedDescription)")
    }
  }

  private func selectCity(_ suggestion: AddressSearchSuggestion) async {
    let enteredText = state.cityText
      .trimmingCharacters(in: .whitespacesAndNewlines)
    state.isResolvingCity = true
    defer { state.isResolvingCity = false }

    do {
      let city = try await addressSearchService.resolveCity(
        from: suggestion,
        locale: Self.searchLocale
      )
      guard state.cityText.trimmingCharacters(in: .whitespacesAndNewlines) == enteredText else {
        return
      }
      state.selectedCity = city
      state.cityText = city.name
      state.citySuggestions = []
      state.citySuggestionsError = nil
      focusedField = .street
    } catch {
      guard state.cityText.trimmingCharacters(in: .whitespacesAndNewlines) == enteredText else {
        return
      }
      state.citySuggestionsError = "Не удалось выбрать город"
      Logger.map.error("City resolution failed: \(error.localizedDescription)")
    }
  }

  private func selectStreet(_ suggestion: AddressSearchSuggestion) {
    state.selectedStreet = suggestion
    state.streetText = suggestion.title
    state.streetSuggestions = []
    state.streetSuggestionsError = nil
    focusedField = .house
  }

  private func submitCity() async {
    if state.selectedCity != nil {
      focusedField = .street
      return
    }

    let enteredCity = state.cityText
      .trimmingCharacters(in: .whitespacesAndNewlines)
    guard !enteredCity.isEmpty else { return }

    let suggestion = state.citySuggestions.first
      ?? AddressSearchSuggestion(title: enteredCity, subtitle: "")
    await selectCity(suggestion)
  }

  private func submitStreet() {
    if state.selectedStreet != nil {
      focusedField = .house
      return
    }

    let enteredStreet = state.streetText
      .trimmingCharacters(in: .whitespacesAndNewlines)
    guard !enteredStreet.isEmpty else { return }

    selectStreet(
      state.streetSuggestions.first
        ?? AddressSearchSuggestion(title: enteredStreet, subtitle: state.selectedCity?.name ?? "")
    )
  }

  private func showAddressOnMap() async {
    guard let city = state.selectedCity,
          let street = state.selectedStreet,
          state.canResolveAddress else { return }

    focusedField = nil
    state.isResolvingAddress = true
    defer { state.isResolvingAddress = false }

    do {
      let selection = try await addressSearchService.resolveAddress(
        city: city,
        street: street,
        house: state.house,
        building: state.building,
        locale: Self.searchLocale
      )
      onSelect(selection)
    } catch {
      state.resolutionError = error.localizedDescription
      Logger.map.error("Address resolution failed: \(error.localizedDescription)")
    }
  }

  private static let searchLocale = Locale(identifier: "ru_RU")
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
