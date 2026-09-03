//
//  AddressDraftTests.swift
//  WBTechTests
//
//  Created by Eyhciurmrn Zmpodackrl on 19.08.2026.
//

import Testing
@testable import WBTech

struct AddressDraftTests {

  @Test func addressToDraftMapsExistingFields() {
    let address = Address(
      id: "addressID",
      coordinates: .init(longitude: 37.62381, latitude: 55.73662),
      addressLine: "Новая Басманная ул., 35 ст1, 59",
      floor: "4",
      entrance: "3",
      intercomCode: "15809",
      comment: nil
    )

    let draft = AddressDraft(address: address)

    #expect(draft.addressLine == address.addressLine)
    #expect(draft.floor == "4")
    #expect(draft.entrance == "3")
    #expect(draft.intercomCode == "15809")
    #expect(draft.comment.isEmpty)
  }

  @Test func draftToAddressMapsExistingFields() {
    let draft = AddressDraft(
      coordinates: .init(longitude: 37.62381, latitude: 55.73662),
      addressLine: "Новая Басманная ул., 35 ст1",
      entrance: " ",
      floor: "4",
      intercomCode: "",
      comment: " Позвонить заранее "
    )

    let address = draft.makeAddress(id: "addressID")

    #expect(address.id == "addressID")
    #expect(address.addressLine == draft.addressLine)
    #expect(address.entrance == nil)
    #expect(address.floor == "4")
    #expect(address.intercomCode == nil)
    #expect(address.comment == "Позвонить заранее")
  }
}
