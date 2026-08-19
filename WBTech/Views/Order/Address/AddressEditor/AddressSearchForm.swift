//
//  AddressSearchForm.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 30.08.2026.
//

import SwiftUI
import UISystem
import OSLog

struct AddressSearchForm: View {

  private enum Field: Hashable {
    case city
    case street
    case house
    case building
  }

  private enum Layout {
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

  @Environment(\.locale) private var locale

  let initialCoordinates: AddressCoordinates
  let addressSearchService: AddressSearchServiceProtocol
  let onSelect: (AddressSearchSelection) -> Void

  @State private var cityText = ""
  @State private var streetText = ""
  @State private var house = ""
  @State private var building = ""

  @State private var selectedCity: AddressSearchCity?
  @State private var selectedStreet: AddressSearchSuggestion?
  @State private var citySuggestions: [AddressSearchSuggestion] = []
  @State private var streetSuggestions: [AddressSearchSuggestion] = []

  @State private var citySuggestionsError: String?
  @State private var streetSuggestionsError: String?
  @State private var resolutionError: String?
  @State private var isResolvingCity = false
  @State private var isResolvingAddress = false
  @State private var didLoadInitialCity = false

  @FocusState private var focusedField: Field?

  var body: some View {
    ScrollView {
      VStack(spacing: Layout.fieldSpacing) {
        citySection
        streetSection

        UnderlinedAddressField(
          title: "Дом",
          text: $house
        )
        .focused($focusedField, equals: .house)
        .submitLabel(.next)
        .disabled(selectedStreet == nil)
        .onSubmit { focusedField = .building }
        .accessibilityIdentifier("addressSearch.house")

        UnderlinedAddressField(
          title: "Корпус/строение",
          text: $building
        )
        .focused($focusedField, equals: .building)
        .submitLabel(.done)
        .disabled(selectedStreet == nil)
        .onSubmit {
          focusedField = nil
          guard canResolveAddress else { return }
          Task { await showAddressOnMap() }
        }
        .accessibilityIdentifier("addressSearch.building")
      }
      .padding(.top, Layout.topPadding)
      .padding(.horizontal, Layout.horizontalPadding)
      .padding(.bottom, Layout.fieldSpacing)
    }
    .scrollDismissesKeyboard(.interactively)
    .safeAreaInset(edge: .bottom, spacing: 0) {
      showOnMapButton
    }
    .task {
      await loadInitialCityIfNeeded()
    }
    .task(id: cityText) {
      await loadCitySuggestions(for: cityText)
    }
    .task(
      id: StreetSearchKey(
        cityID: selectedCity?.id,
        query: streetText
      )
    ) {
      await loadStreetSuggestions(for: streetText)
    }
    .alert(
      "Не удалось найти адрес",
      isPresented: Binding(
        get: { resolutionError != nil },
        set: { if !$0 { resolutionError = nil } }
      )
    ) {
      Button("Повторить") {
        Task { await showAddressOnMap() }
      }
      Button("Отмена", role: .cancel) { }
    } message: {
      Text(resolutionError ?? "Попробуйте ещё раз")
    }
  }

  private var citySection: some View {
    VStack(alignment: .leading, spacing: 0) {
      searchField(
        title: "Город",
        text: cityBinding,
        field: .city,
        isEnabled: true,
        accessibilityIdentifier: "addressSearch.city"
      )

      if focusedField == .city {
        suggestionError(citySuggestionsError)
        suggestionsList(citySuggestions, showsSubtitle: true) { suggestion in
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
        isEnabled: selectedCity != nil,
        accessibilityIdentifier: "addressSearch.street"
      )

      if focusedField == .street {
        suggestionError(streetSuggestionsError)
        suggestionsList(streetSuggestions, showsSubtitle: false) { suggestion in
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
        if isResolvingAddress {
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
        style: canResolveAddress ? .accent : .accentDisabled
      )
    )
    .disabled(!canResolveAddress)
    .padding(.horizontal, Layout.horizontalPadding)
    .padding(.vertical, Layout.buttonVerticalPadding)
    .accessibilityIdentifier("addressSearch.showOnMap")
  }

  private var cityBinding: Binding<String> {
    Binding(
      get: { cityText },
      set: { newValue in
        cityText = newValue
        selectedCity = nil
        selectedStreet = nil
        streetText = ""
        house = ""
        building = ""
        streetSuggestions = []
      }
    )
  }

  private var streetBinding: Binding<String> {
    Binding(
      get: { streetText },
      set: { newValue in
        streetText = newValue
        selectedStreet = nil
        house = ""
        building = ""
      }
    )
  }

  private var canResolveAddress: Bool {
    selectedCity != nil
      && selectedStreet != nil
      && !house.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && !isResolvingAddress
  }

  private func searchField(
    title: String,
    text: Binding<String>,
    field: Field,
    isEnabled: Bool,
    accessibilityIdentifier: String
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
        focusedField = selectedCity == nil ? .city : .street
      case .street:
        focusedField = selectedStreet == nil ? .street : .house
      case .house, .building:
        break
      }
    }
    .accessibilityIdentifier(accessibilityIdentifier)
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
            .padding(.vertical, Layout.suggestionVerticalPadding)
          }
          .buttonStyle(.plain)
          .disabled(isResolvingCity)
          .accessibilityIdentifier("addressSearch.suggestion.\(suggestion.id)")
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

  private func loadInitialCityIfNeeded() async {
    guard !didLoadInitialCity else { return }
    didLoadInitialCity = true

    do {
      if let city = try await addressSearchService.city(
        at: initialCoordinates,
        locale: locale
      ) {
        selectedCity = city
        cityText = city.name
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
    guard selectedCity == nil, !query.isEmpty else {
      citySuggestions = []
      citySuggestionsError = nil
      return
    }

    do {
      try await Task.sleep(for: .milliseconds(250))
      let suggestions = try await addressSearchService.citySuggestions(for: query)
      guard !Task.isCancelled,
            selectedCity == nil,
            cityText.trimmingCharacters(in: .whitespacesAndNewlines) == query else { return }
      citySuggestions = suggestions
      citySuggestionsError = nil
    } catch is CancellationError {
      return
    } catch {
      guard cityText.trimmingCharacters(in: .whitespacesAndNewlines) == query else { return }
      citySuggestions = []
      citySuggestionsError = "Не удалось загрузить города"
      Logger.map.error("City suggestions failed: \(error.localizedDescription)")
    }
  }

  private func loadStreetSuggestions(for query: String) async {
    let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let city = selectedCity,
          selectedStreet == nil,
          !query.isEmpty else {
      streetSuggestions = []
      streetSuggestionsError = nil
      return
    }

    do {
      try await Task.sleep(for: .milliseconds(250))
      let suggestions = try await addressSearchService.streetSuggestions(
        for: query,
        city: city
      )
      guard !Task.isCancelled,
            selectedCity?.id == city.id,
            selectedStreet == nil,
            streetText.trimmingCharacters(in: .whitespacesAndNewlines) == query else { return }
      streetSuggestions = suggestions
      streetSuggestionsError = nil
    } catch is CancellationError {
      return
    } catch {
      guard selectedCity?.id == city.id,
            streetText.trimmingCharacters(in: .whitespacesAndNewlines) == query else { return }
      streetSuggestions = []
      streetSuggestionsError = "Не удалось загрузить улицы"
      Logger.map.error("Street suggestions failed: \(error.localizedDescription)")
    }
  }

  private func selectCity(_ suggestion: AddressSearchSuggestion) async {
    isResolvingCity = true
    defer { isResolvingCity = false }

    do {
      let city = try await addressSearchService.resolveCity(from: suggestion)
      selectedCity = city
      cityText = city.name
      citySuggestions = []
      citySuggestionsError = nil
      focusedField = .street
    } catch {
      citySuggestionsError = "Не удалось выбрать город"
      Logger.map.error("City resolution failed: \(error.localizedDescription)")
    }
  }

  private func selectStreet(_ suggestion: AddressSearchSuggestion) {
    selectedStreet = suggestion
    streetText = suggestion.title
    streetSuggestions = []
    streetSuggestionsError = nil
    focusedField = .house
  }

  private func showAddressOnMap() async {
    guard let city = selectedCity,
          let street = selectedStreet,
          canResolveAddress else { return }

    focusedField = nil
    isResolvingAddress = true
    defer { isResolvingAddress = false }

    do {
      let selection = try await addressSearchService.resolveAddress(
        city: city,
        street: street,
        house: house,
        building: building,
        locale: locale
      )
      onSelect(selection)
    } catch {
      resolutionError = error.localizedDescription
      Logger.map.error("Address resolution failed: \(error.localizedDescription)")
    }
  }
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
