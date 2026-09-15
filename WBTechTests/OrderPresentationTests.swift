import Testing
import UISystem
@testable import WBTech

struct OrderPresentationTests {

  @Test func activeOrderUsesDefaultETA() {
    #expect(makeOrder(status: .active).statusTitle() == "Доставим через 12 минут")
  }

  @Test func activeOrderUsesProvidedETAAndPluralForm() {
    #expect(makeOrder(status: .active).statusTitle(etaMinutes: 21) == "Доставим через 21 минута")
  }

  @Test func completedOrderFormatsDeliveryDate() {
    let title = makeOrder(
      status: .completed,
      deliveryDate: "2026-07-15 18:34:00"
    ).statusTitle()

    #expect(title == "Доставили 15 июля в 18:34")
  }

  @Test func completedOrderWithoutValidDateUsesFallback() {
    #expect(
      makeOrder(status: .completed, deliveryDate: "not-a-date").statusTitle()
        == "Заказ доставлен"
    )
  }

  @Test func addressDetailsContainOnlyAvailableValues() {
    let address = OrderAddress(
      coordinates: .init(longitude: 92.87, latitude: 56.01),
      addressLine: "Новая Басманная ул., 35",
      floor: "3",
      entrance: nil,
      intercomCode: "15809",
      comment: "Позвонить перед доставкой"
    )

    #expect(
      address.uiConfig().additionalInfo(includingComment: true)
        == "3 этаж, код домофона 15809\nПозвонить перед доставкой"
    )
  }

  private func makeOrder(
    status: OrderStatus,
    deliveryDate: String? = nil
  ) -> Order {
    Order(
      id: "order",
      status: status,
      deliveryDate: deliveryDate,
      address: OrderAddress(
        coordinates: .init(longitude: 92.87, latitude: 56.01),
        addressLine: "Новая Басманная ул., 35",
        floor: nil,
        entrance: nil,
        intercomCode: nil,
        comment: nil
      ),
      orderPrice: 900,
      deliveryPrice: 100,
      totalPrice: 1_000,
      totalItems: 1,
      items: []
    )
  }
}
