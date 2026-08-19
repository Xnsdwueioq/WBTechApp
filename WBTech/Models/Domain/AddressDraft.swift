//
//  AddressDraft.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 19.08.2026.
//

import Foundation

struct AddressDraft: Equatable, Sendable {
  var coordinates: AddressCoordinates
  var addressLine: String
  var apartment: String
  var entrance: String
  var floor: String
  var intercomCode: String
  var comment: String

  init(
    coordinates: AddressCoordinates,
    addressLine: String,
    apartment: String = "",
    entrance: String = "",
    floor: String = "",
    intercomCode: String = "",
    comment: String = ""
  ) {
    self.coordinates = coordinates
    self.addressLine = addressLine
    self.apartment = apartment
    self.entrance = entrance
    self.floor = floor
    self.intercomCode = intercomCode
    self.comment = comment
  }

  init(address: Address) {
    self.init(
      coordinates: address.coordinates,
      addressLine: address.addressLine,
      entrance: address.entrance ?? "",
      floor: address.floor ?? "",
      intercomCode: address.intercomCode ?? "",
      comment: address.comment ?? ""
    )
  }

  var isValid: Bool {
    !addressLine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  func makeAddress(id: String) -> Address {
    Address(
      id: id,
      coordinates: coordinates,
      addressLine: addressLine,
      floor: AddressDraftConversion.optionalValue(floor),
      entrance: AddressDraftConversion.optionalValue(entrance),
      intercomCode: AddressDraftConversion.optionalValue(intercomCode),
      comment: AddressDraftConversion.optionalValue(comment)
    )
  }
}

private enum AddressDraftConversion {

  static func optionalValue(_ value: String) -> String? {
    let value = value.trimmingCharacters(in: .whitespacesAndNewlines)
    return value.isEmpty ? nil : value
  }
}
