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

  private let cityCompleter = LocalSearchCompleter(
    addressFilter: MKAddressFilter(including: .locality)
  )

  func citySuggestions(
    for query: String
  ) async throws -> [AddressSearchSuggestion] {
    try await cityCompleter.results(query: query)
  }

  func resolveCity(
    from suggestion: AddressSearchSuggestion,
    locale: Locale
  ) async throws -> AddressSearchCity {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = suggestion.searchText
    request.resultTypes = .address
    request.addressFilter = MKAddressFilter(including: .locality)

    guard let mapItem = try await MKLocalSearch(request: request).start().mapItems.first else {
      throw AddressSearchServiceError.noResults
    }

    let coordinates = Self.coordinates(from: mapItem.location.coordinate)
    let localizedCity = try await city(at: coordinates, locale: locale)

    return AddressSearchCity(
      name: localizedCity?.name ?? suggestion.title,
      context: localizedCity?.context ?? suggestion.subtitle,
      coordinates: coordinates
    )
  }

  func streetSuggestions(
    for query: String,
    city: AddressSearchCity
  ) async throws -> [AddressSearchSuggestion] {
    let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !query.isEmpty else { return [] }

    let searchText = query.lowercased().hasPrefix("ул")
      ? query
      : "улица \(query)"
    let request = MKLocalSearch.Request(
      naturalLanguageQuery: searchText,
      region: Self.searchRegion(for: city.coordinates)
    )
    request.regionPriority = .required
    request.resultTypes = .address
    let mapItems = try await MKLocalSearch(request: request).start().mapItems

    var seenTitles = Set<String>()
    return mapItems.compactMap { mapItem in
      let title = mapItem.name?
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

  func addressLine(
    at coordinates: AddressCoordinates,
    locale: Locale
  ) async throws -> String {
    let location = CLLocation(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude
    )

    guard let request = MKReverseGeocodingRequest(location: location) else {
      throw AddressSearchServiceError.invalidRequest
    }

    request.preferredLocale = locale

    guard let mapItem = try await request.mapItems.first,
          let address = mapItem.address else {
      throw AddressSearchServiceError.noResults
    }

    let addressLine = address.fullAddress
      .trimmingCharacters(in: .whitespacesAndNewlines)
    guard !addressLine.isEmpty else {
      throw AddressSearchServiceError.noResults
    }

    return addressLine
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
private final class LocalSearchCompleter:
  NSObject,
  @preconcurrency MKLocalSearchCompleterDelegate {

  private let completer = MKLocalSearchCompleter()
  private var continuation: CheckedContinuation<[AddressSearchSuggestion], any Error>?
  private var requestID: UUID?

  init(
    addressFilter: MKAddressFilter = .includingAll
  ) {
    super.init()
    completer.resultTypes = .address
    completer.addressFilter = addressFilter
    completer.delegate = self
  }

  func results(query: String) async throws -> [AddressSearchSuggestion] {
    let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !query.isEmpty else { return [] }
    guard !Task.isCancelled else { throw CancellationError() }

    let requestID = UUID()
    cancelCurrentRequest()
    self.requestID = requestID
    return try await withTaskCancellationHandler {
      try await withCheckedThrowingContinuation { continuation in
        self.continuation = continuation
        completer.queryFragment = query
      }
    } onCancel: {
      Task { @MainActor [weak self] in
        self?.cancel(requestID: requestID)
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

  private func cancel(requestID: UUID) {
    guard self.requestID == requestID else { return }
    cancelCurrentRequest()
  }

  private func cancelCurrentRequest() {
    completer.cancel()
    finish(with: .failure(CancellationError()))
  }

  private func finish(
    with result: Result<[AddressSearchSuggestion], any Error>
  ) {
    guard let continuation else { return }
    self.continuation = nil
    requestID = nil
    continuation.resume(with: result)
  }
}
