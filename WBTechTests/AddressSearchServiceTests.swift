//
//  AddressSearchServiceTests.swift
//  WBTechTests
//
//  Created by Eyhciurmrn Zmpodackrl on 30.08.2026.
//

import Testing
@testable import WBTech

struct AddressSearchServiceTests {

  @Test func addressLineIncludesHouseAndTrimsValues() throws {
    let addressLine = try MapKitAddressSearchService.makeAddressLine(
      city: " Челябинск ",
      street: " ул. Энгельса ",
      house: " 3 ",
      building: ""
    )

    #expect(addressLine == "Челябинск, ул. Энгельса, д. 3")
  }

  @Test func addressLineIncludesNonEmptyBuilding() throws {
    let addressLine = try MapKitAddressSearchService.makeAddressLine(
      city: "Челябинск",
      street: "ул. Энгельса",
      house: "3",
      building: " 2 "
    )

    #expect(addressLine == "Челябинск, ул. Энгельса, д. 3, корп. 2")
  }

  @Test func emptyBuildingIsOmitted() throws {
    let addressLine = try MapKitAddressSearchService.makeAddressLine(
      city: "Челябинск",
      street: "ул. Энгельса",
      house: "3",
      building: " \n "
    )

    #expect(!addressLine.contains("корп."))
  }

  @Test func emptyHouseIsRejected() {
    #expect(throws: AddressSearchServiceError.invalidRequest) {
      try MapKitAddressSearchService.makeAddressLine(
        city: "Челябинск",
        street: "ул. Энгельса",
        house: "  ",
        building: "2"
      )
    }
  }
}
