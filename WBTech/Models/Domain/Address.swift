//

struct Address: Identifiable, Hashable, Sendable {
  let id: String
  let addressLine: String
  let floor: String?
  let entrance: String?
  let intercomCode: String?
}
