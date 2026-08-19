//
//  AddressSearchServiceProtocol.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 30.08.2026.
//

import Foundation

struct AddressSearchSuggestion: Identifiable, Equatable, Sendable {
  let title: String
  let subtitle: String

  var id: String {
    title + "::" + subtitle
  }

  var searchText: String {
    [title, subtitle]
      .filter { !$0.isEmpty }
      .joined(separator: ", ")
  }
}

struct AddressSearchCity: Identifiable, Equatable, Sendable {
  let name: String
  let context: String
  let coordinates: AddressCoordinates

  var id: String {
    name + "::" + context
  }
}

struct AddressSearchSelection: Equatable, Sendable {
  let coordinates: AddressCoordinates
  let addressLine: String
}

@MainActor
protocol AddressSearchServiceProtocol: AnyObject {

  func citySuggestions(
    for query: String
  ) async throws -> [AddressSearchSuggestion]

  func resolveCity(
    from suggestion: AddressSearchSuggestion
  ) async throws -> AddressSearchCity

  func streetSuggestions(
    for query: String,
    city: AddressSearchCity
  ) async throws -> [AddressSearchSuggestion]

  func city(
    at coordinates: AddressCoordinates,
    locale: Locale
  ) async throws -> AddressSearchCity?

  func resolveAddress(
    city: AddressSearchCity,
    street: AddressSearchSuggestion,
    house: String,
    building: String,
    locale: Locale
  ) async throws -> AddressSearchSelection
}
