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

extension Address {
  
  static let `default`: Address = Address(
    id: "address1",
    coordinates: .init(longitude: 1.2, latitude: 0.9),
    addressLine: "Новая Басманная ул., 35 ст1, 59",
    floor: "3",
    entrance: "4",
    intercomCode: "15809",
    comment: "Какой-то комментарий"
  )
  
}
