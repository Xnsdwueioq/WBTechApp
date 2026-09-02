import Foundation
import OSLog

enum AddressLoadState: Equatable, Sendable {
  case idle
  case loading
  case loaded
  case failed
}

struct AddressUserError: Identifiable, Equatable, Sendable {
  let id = UUID()
  let title: String
  let message: String
}

enum AddressStoreError: LocalizedError {
  case unavailable
  case invalidDraft

  var errorDescription: String? {
    switch self {
    case .unavailable:
      "Дождитесь загрузки адресов или повторите синхронизацию."
    case .invalidDraft:
      "Укажите адрес перед сохранением."
    }
  }
}

@MainActor
@Observable
final class AddressStore {

  private(set) var addresses: [Address] = []
  private(set) var selectedAddressID: String?
  private(set) var loadState: AddressLoadState = .idle
  private(set) var isMutating = false
  private(set) var userError: AddressUserError?

  private let orderService: OrderServiceProtocol

  init(
    addresses: [Address] = [],
    selectedAddressID: String? = nil,
    orderService: OrderServiceProtocol
  ) {
    self.addresses = addresses
    self.selectedAddressID = Self.reconciledSelection(
      selectedAddressID,
      addresses: addresses
    )
    self.orderService = orderService
    self.loadState = addresses.isEmpty ? .idle : .loaded
  }

  var selectedAddress: Address? {
    guard let selectedAddressID else { return nil }
    return addresses.first { $0.id == selectedAddressID }
  }

  var canMutate: Bool {
    loadState == .loaded && !isMutating
  }

  func loadIfNeeded() async {
    guard loadState == .idle else { return }
    await reload()
  }

  func reload() async {
    guard !isMutating else { return }
    loadState = .loading

    do {
      apply(try await orderService.fetchAddresses())
    } catch {
      loadState = .failed
      presentError(title: "Не удалось загрузить адреса", error: error)
      Logger.order.error("Unable to load addresses: \(error.localizedDescription)")
    }
  }

  func confirmSelection(id: String) {
    guard addresses.contains(where: { $0.id == id }) else { return }
    selectedAddressID = id
  }

  func createAddress(_ draft: AddressDraft) async throws -> String? {
    guard canMutate else { throw AddressStoreError.unavailable }
    guard draft.isValid else { throw AddressStoreError.invalidDraft }
    let previousIDs = Set(addresses.map(\.id))
    let confirmedSelection = selectedAddressID

    isMutating = true
    defer { isMutating = false }

    try await orderService.createAddress(draft)

    do {
      let refreshed = try await orderService.fetchAddresses()
      addresses = refreshed
      selectedAddressID = confirmedSelection.map {
        Self.reconciledSelection($0, addresses: refreshed)
      } ?? nil
      loadState = .loaded
      let createdAddresses = refreshed.filter {
        !previousIDs.contains($0.id) && draft.matches($0)
      }
      return createdAddresses.count == 1 ? createdAddresses[0].id : nil
    } catch {
      loadState = .failed
      presentError(title: "Адрес создан, но список не обновлён", error: error)
      return nil
    }
  }

  func updateAddress(id: String, draft: AddressDraft) async throws {
    guard canMutate else { throw AddressStoreError.unavailable }
    guard draft.isValid else { throw AddressStoreError.invalidDraft }

    isMutating = true
    defer { isMutating = false }

    try await orderService.updateAddress(id: id, draft: draft)
    addresses = addresses.map { $0.id == id ? draft.makeAddress(id: id) : $0 }
    await refreshAfterMutation(title: "Адрес обновлён, но список не синхронизирован")
  }

  func deleteAddress(id: String) async throws {
    guard canMutate else { throw AddressStoreError.unavailable }

    isMutating = true
    defer { isMutating = false }

    try await orderService.deleteAddress(id: id)
    addresses.removeAll { $0.id == id }
    selectedAddressID = Self.reconciledSelection(
      selectedAddressID,
      addresses: addresses
    )
    await refreshAfterMutation(title: "Адрес удалён, но список не синхронизирован")
  }

  func dismissError() {
    userError = nil
  }

  private func refreshAfterMutation(title: String) async {
    do {
      apply(try await orderService.fetchAddresses())
    } catch {
      loadState = .failed
      presentError(title: title, error: error)
    }
  }

  private func apply(_ addresses: [Address]) {
    self.addresses = addresses
    selectedAddressID = Self.reconciledSelection(
      selectedAddressID,
      addresses: addresses
    )
    loadState = .loaded
  }

  private func presentError(title: String, error: Error) {
    userError = AddressUserError(
      title: title,
      message: error.localizedDescription
    )
  }

  private static func reconciledSelection(
    _ selectedAddressID: String?,
    addresses: [Address]
  ) -> String? {
    guard !addresses.isEmpty else { return nil }
    if let selectedAddressID,
       addresses.contains(where: { $0.id == selectedAddressID }) {
      return selectedAddressID
    }
    return addresses[0].id
  }
}

private extension AddressDraft {
  func matches(_ address: Address) -> Bool {
    makeAddress(id: address.id) == address
  }
}
