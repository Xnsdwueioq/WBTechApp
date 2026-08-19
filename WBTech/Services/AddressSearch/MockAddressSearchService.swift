//
//  MockAddressSearchService.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 30.08.2026.
//

import Foundation

@MainActor
final class MockAddressSearchService: AddressSearchServiceProtocol {

  private let chelyabinsk = AddressSearchCity(
    name: "Челябинск",
    context: "Челябинск, Челябинская область",
    coordinates: .init(longitude: 61.4026, latitude: 55.1603)
  )

  func citySuggestions(
    for query: String
  ) async throws -> [AddressSearchSuggestion] {
    Self.filtered(
      [
        AddressSearchSuggestion(
          title: "Челябинск",
          subtitle: "Челябинская область"
        ),
        AddressSearchSuggestion(
          title: "Москва",
          subtitle: "Москва"
        )
      ],
      query: query
    )
  }

  func resolveCity(
    from suggestion: AddressSearchSuggestion
  ) async throws -> AddressSearchCity {
    if suggestion.title == chelyabinsk.name {
      return chelyabinsk
    }

    return AddressSearchCity(
      name: suggestion.title,
      context: suggestion.searchText,
      coordinates: .init(longitude: 37.6176, latitude: 55.7558)
    )
  }

  func streetSuggestions(
    for query: String,
    city: AddressSearchCity
  ) async throws -> [AddressSearchSuggestion] {
    Self.filtered(
      [
        .init(title: "ул. Энгельса", subtitle: city.name),
        .init(title: "ул. Энтузиастов", subtitle: city.name),
        .init(title: "ул. Энергетиков", subtitle: city.name),
        .init(title: "ул. Электростальская", subtitle: city.name)
      ],
      query: query
    )
  }

  func city(
    at coordinates: AddressCoordinates,
    locale: Locale
  ) async throws -> AddressSearchCity? {
    chelyabinsk
  }

  func resolveAddress(
    city: AddressSearchCity,
    street: AddressSearchSuggestion,
    house: String,
    building: String,
    locale: Locale
  ) async throws -> AddressSearchSelection {
    AddressSearchSelection(
      coordinates: city.coordinates,
      addressLine: try MapKitAddressSearchService.makeAddressLine(
        city: city.name,
        street: street.title,
        house: house,
        building: building
      )
    )
  }

  private nonisolated static func filtered(
    _ suggestions: [AddressSearchSuggestion],
    query: String
  ) -> [AddressSearchSuggestion] {
    let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !query.isEmpty else { return [] }
    return suggestions.filter { $0.searchText.localizedStandardContains(query) }
  }
}
