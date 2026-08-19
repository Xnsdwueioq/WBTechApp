//
//  MapKitAddressSearchService.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 30.08.2026.
//

import Foundation
import MapKit

enum AddressSearchServiceError: LocalizedError, Equatable, Sendable {
  case invalidRequest
  case noResults

  var errorDescription: String? {
    switch self {
    case .invalidRequest:
      "Не удалось сформировать запрос адреса"
    case .noResults:
      "Адрес не найден"
    }
  }
}

@MainActor
final class MapKitAddressSearchService: AddressSearchServiceProtocol {

  func citySuggestions(
    for query: String
  ) async throws -> [AddressSearchSuggestion] {
    try await suggestions(
      query: query,
      addressFilter: MKAddressFilter(including: .locality)
    )
  }

  func resolveCity(
    from suggestion: AddressSearchSuggestion
  ) async throws -> AddressSearchCity {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = suggestion.searchText
    request.resultTypes = .address
    request.addressFilter = MKAddressFilter(including: .locality)

    guard let mapItem = try await MKLocalSearch(request: request).start().mapItems.first else {
      throw AddressSearchServiceError.noResults
    }

    let name = mapItem.addressRepresentations?.cityName ?? suggestion.title
    let context = mapItem.addressRepresentations?.cityWithContext
      ?? suggestion.subtitle

    return AddressSearchCity(
      name: name,
      context: context,
      coordinates: Self.coordinates(from: mapItem.location.coordinate)
    )
  }

  func streetSuggestions(
    for query: String,
    city: AddressSearchCity
  ) async throws -> [AddressSearchSuggestion] {
    let suggestions = try await suggestions(
      query: query,
      region: Self.searchRegion(for: city.coordinates),
      regionPriority: .required
    )

    var seenTitles = Set<String>()
    return suggestions.compactMap { suggestion in
      let title = suggestion.title
        .split(separator: ",", maxSplits: 1)
        .first?
        .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      guard !title.isEmpty,
            seenTitles.insert(title).inserted else { return nil }
      return AddressSearchSuggestion(title: title, subtitle: city.name)
    }
  }

  func city(
    at coordinates: AddressCoordinates,
    locale: Locale
  ) async throws -> AddressSearchCity? {
    let location = CLLocation(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude
    )

    guard let request = MKReverseGeocodingRequest(location: location) else {
      throw AddressSearchServiceError.invalidRequest
    }

    request.preferredLocale = locale

    guard let mapItem = try await request.mapItems.first,
          let name = mapItem.addressRepresentations?.cityName else {
      return nil
    }

    return AddressSearchCity(
      name: name,
      context: mapItem.addressRepresentations?.cityWithContext ?? name,
      coordinates: coordinates
    )
  }

  func resolveAddress(
    city: AddressSearchCity,
    street: AddressSearchSuggestion,
    house: String,
    building: String,
    locale: Locale
  ) async throws -> AddressSearchSelection {
    let enteredAddressLine = try Self.makeAddressLine(
      city: city.name,
      street: street.title,
      house: house,
      building: building
    )

    guard let request = MKGeocodingRequest(addressString: enteredAddressLine) else {
      throw AddressSearchServiceError.invalidRequest
    }

    request.region = Self.searchRegion(for: city.coordinates)
    request.preferredLocale = locale

    guard let mapItem = try await request.mapItems.first else {
      throw AddressSearchServiceError.noResults
    }

    return AddressSearchSelection(
      coordinates: Self.coordinates(from: mapItem.location.coordinate),
      addressLine: enteredAddressLine
    )
  }

  nonisolated static func makeAddressLine(
    city: String,
    street: String,
    house: String,
    building: String
  ) throws -> String {
    let city = city.trimmingCharacters(in: .whitespacesAndNewlines)
    let street = street.trimmingCharacters(in: .whitespacesAndNewlines)
    let house = house.trimmingCharacters(in: .whitespacesAndNewlines)
    let building = building.trimmingCharacters(in: .whitespacesAndNewlines)

    guard !city.isEmpty,
          !street.isEmpty,
          !house.isEmpty else {
      throw AddressSearchServiceError.invalidRequest
    }

    var components = [city, street, "д. \(house)"]
    if !building.isEmpty {
      components.append("корп. \(building)")
    }

    return components.joined(separator: ", ")
  }

  private func suggestions(
    query: String,
    addressFilter: MKAddressFilter = .includingAll,
    region: MKCoordinateRegion? = nil,
    regionPriority: MKLocalSearchRegionPriority = .default
  ) async throws -> [AddressSearchSuggestion] {
    let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !query.isEmpty else { return [] }

    let request = LocalSearchCompletionRequest(
      query: query,
      addressFilter: addressFilter,
      region: region,
      regionPriority: regionPriority
    )
    return try await request.results()
  }

  private nonisolated static func searchRegion(
    for coordinates: AddressCoordinates
  ) -> MKCoordinateRegion {
    MKCoordinateRegion(
      center: CLLocationCoordinate2D(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude
      ),
      span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    )
  }

  private nonisolated static func coordinates(
    from coordinate: CLLocationCoordinate2D
  ) -> AddressCoordinates {
    AddressCoordinates(
      longitude: coordinate.longitude,
      latitude: coordinate.latitude
    )
  }
}

@MainActor
private final class LocalSearchCompletionRequest:
  NSObject,
  @preconcurrency MKLocalSearchCompleterDelegate {

  private let completer: MKLocalSearchCompleter
  private let query: String
  private var continuation: CheckedContinuation<[AddressSearchSuggestion], any Error>?

  init(
    query: String,
    addressFilter: MKAddressFilter,
    region: MKCoordinateRegion?,
    regionPriority: MKLocalSearchRegionPriority
  ) {
    let completer = MKLocalSearchCompleter()
    completer.resultTypes = .address
    completer.addressFilter = addressFilter
    completer.regionPriority = regionPriority
    if let region {
      completer.region = region
    }

    self.completer = completer
    self.query = query
    super.init()
    completer.delegate = self
  }

  func results() async throws -> [AddressSearchSuggestion] {
    guard !Task.isCancelled else { throw CancellationError() }

    return try await withTaskCancellationHandler {
      try await withCheckedThrowingContinuation { continuation in
        self.continuation = continuation
        completer.queryFragment = query
      }
    } onCancel: {
      Task { @MainActor [weak self] in
        self?.cancel()
      }
    }
  }

  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    var seenIDs = Set<String>()
    let suggestions: [AddressSearchSuggestion] = completer.results.compactMap { completion -> AddressSearchSuggestion? in
      let suggestion = AddressSearchSuggestion(
        title: completion.title.trimmingCharacters(in: .whitespacesAndNewlines),
        subtitle: completion.subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
      )
      guard !suggestion.title.isEmpty,
            seenIDs.insert(suggestion.id).inserted else { return nil }
      return suggestion
    }

    finish(with: .success(suggestions))
  }

  func completer(
    _ completer: MKLocalSearchCompleter,
    didFailWithError error: any Error
  ) {
    finish(with: .failure(error))
  }

  private func cancel() {
    completer.cancel()
    finish(with: .failure(CancellationError()))
  }

  private func finish(
    with result: Result<[AddressSearchSuggestion], any Error>
  ) {
    guard let continuation else { return }
    self.continuation = nil
    completer.delegate = nil
    continuation.resume(with: result)
  }
}
