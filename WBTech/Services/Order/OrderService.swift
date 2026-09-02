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

  func createAddress(_ draft: AddressDraft) async throws {
    let response = try await client.createAddress(
      .init(body: .json(Self.addressDTO(from: draft)))
    )
    _ = try response.ok
  }

  func updateAddress(id: String, draft: AddressDraft) async throws {
    let response = try await client.updateAddress(
      .init(
        path: .init(id: id),
        body: .json(Self.addressDTO(from: draft))
      )
    )
    _ = try response.ok
  }

  func deleteAddress(id: String) async throws {
    let response = try await client.deleteAddress(
      .init(path: .init(id: id))
    )
    _ = try response.ok
  }

  func createOrder(paymentMethod: String, addressID: String) async throws {
    let response = try await client.createOrder(
      .init(body: .json(.init(paymentMethod: paymentMethod, addressID: addressID)))
    )
    _ = try response.ok
  }

}

private extension OrderService {

  static func addressDTO(
    from draft: AddressDraft
  ) -> Components.Schemas.Address {
    Components.Schemas.Address(
      coordinates: [
        draft.coordinates.longitude,
        draft.coordinates.latitude
      ],
      addressLine: draft.addressLine.trimmingCharacters(in: .whitespacesAndNewlines),
      floor: draft.floor.nilIfEmpty,
      entrance: draft.entrance.nilIfEmpty,
      intercomCode: draft.intercomCode.nilIfEmpty,
      comment: draft.comment.nilIfEmpty
    )
  }

  static func address(from dto: AddressDTO) -> Address? {
    guard let id = dto.value2.id else { return nil }
    guard dto.value1.coordinates.count == 2 else { return nil }
    let longitude = dto.value1.coordinates[0]
    let latitude = dto.value1.coordinates[1]
    return Address(
      id: id,
      coordinates: .init(
        longitude: longitude,
        latitude: latitude
      ),
      addressLine: dto.value1.addressLine,
      floor: dto.value1.floor,
      entrance: dto.value1.entrance,
      intercomCode: dto.value1.intercomCode,
      comment: dto.value1.comment
    )
  }

}

private extension String {
  var nilIfEmpty: String? {
    let normalized = trimmingCharacters(in: .whitespacesAndNewlines)
    return normalized.isEmpty ? nil : normalized
  }
}
