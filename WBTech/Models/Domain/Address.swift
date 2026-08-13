//

struct AddressCoordinates: Hashable, Sendable {
  let longitude: Double
  let latitude: Double
}

struct Address: Identifiable, Hashable, Sendable {
  let id: String
  let coordinates: AddressCoordinates
  let addressLine: String
  let floor: String?
  let entrance: String?
  let intercomCode: String?
  let comment: String?
}
