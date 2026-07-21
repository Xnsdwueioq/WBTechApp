//

import Foundation

actor OrderService: OrderServiceProtocol {

  typealias AddressDTO = Operations.getAddresses.Output.Ok.Body.jsonPayloadPayload

  private let client: Client

  init(token: String) {
    self.client = APIClientFactory.make(token: token)
  }

  func fetchAddresses() async throws -> [Address] {
    let response = try await client.getAddresses(.init())
    let payload = try response.ok.body.json
    return payload.compactMap(Self.address(from:))
  }

  func createOrder(paymentMethod: String, addressID: String) async throws {
    let response = try await client.createOrder(
      .init(body: .json(.init(paymentMethod: paymentMethod, addressID: addressID)))
    )
    _ = try response.ok
  }

}

private extension OrderService {

  static func address(from dto: AddressDTO) -> Address? {
    guard let id = dto.value2.id else { return nil }
    return Address(
      id: id,
      addressLine: dto.value1.addressLine,
      floor: dto.value1.floor,
      entrance: dto.value1.entrance,
      intercomCode: dto.value1.intercomCode
    )
  }

}
