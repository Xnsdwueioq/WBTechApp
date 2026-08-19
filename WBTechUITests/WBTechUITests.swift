//

import XCTest

final class WBTechUITests: XCTestCase {
  
  override func setUpWithError() throws {
    
    continueAfterFailure = false
    
  }
  
  @MainActor
  func testCatalogFlow() throws {

    let app = XCUIApplication()
    app.launchArguments = ["UITESTS"]
    app.launch()

    XCTAssertTrue(app.buttons["Каталог"].waitForExistence(timeout: 3))
    let category = app.buttons["Сладенькое"]
    XCTAssertTrue(category.waitForExistence(timeout: 3))

    category.tap()

    XCTAssertTrue(app.staticTexts["От Даркстора"].waitForExistence(timeout: 3))
    XCTAssertTrue(app.staticTexts["Сладенькое"].waitForExistence(timeout: 3))

    let removeButton = app.buttons["Убрать из корзины"].firstMatch
    XCTAssertTrue(removeButton.waitForExistence(timeout: 3))
    removeButton.tap()
    XCTAssertTrue(app.buttons["В корзину"].firstMatch.waitForExistence(timeout: 3))
  }

  @MainActor
  func testManualAddressSearchFlow() throws {
    let app = XCUIApplication()
    app.launchArguments = ["UITESTS"]
    app.launch()

    let cartTab = app.buttons["Корзина"]
    XCTAssertTrue(cartTab.waitForExistence(timeout: 3))
    cartTab.tap()

    let addressButton = app.buttons["cart.address"]
    XCTAssertTrue(addressButton.waitForExistence(timeout: 5))
    addressButton.tap()

    let createAddressButton = app.buttons["addresses.create"]
    XCTAssertTrue(createAddressButton.waitForExistence(timeout: 5))
    createAddressButton.tap()

    let manualEntryButton = app.buttons["addressEditor.manualEntry"]
    XCTAssertTrue(manualEntryButton.waitForExistence(timeout: 5))
    manualEntryButton.tap()

    let streetField = app.textFields["addressSearch.street"]
    XCTAssertTrue(streetField.waitForExistence(timeout: 5))
    streetField.tap()
    streetField.typeText("Э")

    let streetSuggestion = app.buttons[
      "addressSearch.suggestion.ул. Энгельса::Челябинск"
    ]
    XCTAssertTrue(streetSuggestion.waitForExistence(timeout: 3))
    streetSuggestion.tap()

    let houseField = app.textFields["addressSearch.house"]
    XCTAssertTrue(houseField.waitForExistence(timeout: 3))
    houseField.tap()
    houseField.typeText("3")

    let showOnMapButton = app.buttons["addressSearch.showOnMap"]
    XCTAssertTrue(showOnMapButton.isEnabled)
    showOnMapButton.tap()

    let addressLine = app.staticTexts["addressEditor.addressLine"]
    XCTAssertTrue(addressLine.waitForExistence(timeout: 5))
    XCTAssertEqual(addressLine.label, "Челябинск, ул. Энгельса, д. 3")
  }
}
