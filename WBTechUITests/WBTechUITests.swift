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
  func testOrderDetailsOpensAfterSubmittingOrder() throws {
    let app = XCUIApplication()
    app.launchArguments = ["UITESTS"]
    app.launch()

    let cartTab = app.buttons["Корзина"]
    XCTAssertTrue(cartTab.waitForExistence(timeout: 3))
    cartTab.tap()

    let submitOrderButton = app.buttons["Заказать"]
    XCTAssertTrue(submitOrderButton.waitForExistence(timeout: 5))
    XCTAssertTrue(submitOrderButton.isEnabled)
    submitOrderButton.tap()

    XCTAssertTrue(app.staticTexts["Заказ оформлен"].waitForExistence(timeout: 5))

    let closeButton = app.buttons["Закрыть"]
    XCTAssertTrue(closeButton.waitForExistence(timeout: 3))
    closeButton.tap()

    XCTAssertTrue(
      app.staticTexts["Доставим через 12 минут"].waitForExistence(timeout: 5)
    )
    XCTAssertTrue(app.buttons["Повторить заказ"].exists)
  }
}
