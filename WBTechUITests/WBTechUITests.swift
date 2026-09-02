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
}
