//
//  AddressSearchForm+Search.swift
//  WBTech
//
//  Created by Valeriy Solovey on 15.09.2026.
//

import SwiftUI
import OSLog

extension AddressSearchForm {
  func loadInitialCity() async {
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

  func loadCitySuggestions(for query: String) async {
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

  func loadStreetSuggestions(for query: String) async {
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

  func selectCity(_ suggestion: AddressSearchSuggestion) async {
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

  func selectStreet(_ suggestion: AddressSearchSuggestion) {
    state.selectedStreet = suggestion
    state.streetText = suggestion.title
    state.streetSuggestions = []
    state.streetSuggestionsError = nil
    focusedField = .house
  }

  func submitCity() async {
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

  func submitStreet() {
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

  func showAddressOnMap() async {
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

}
