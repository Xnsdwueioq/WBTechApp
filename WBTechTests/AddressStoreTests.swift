import Testing
@testable import WBTech

@MainActor
struct AddressStoreTests {

  @Test func loadSelectsFirstServerAddress() async {
    let first = Address.fixture(id: "first", line: "Первый")
    let second = Address.fixture(id: "second", line: "Второй")
    let store = AddressStore(
      orderService: FakeOrderService(fetchResults: [.success([first, second])])
    )

    await store.loadIfNeeded()

    #expect(store.addresses == [first, second])
    #expect(store.selectedAddressID == first.id)
    #expect(store.loadState == .loaded)
  }

  @Test func createFindsNewAddressWithoutConfirmingIt() async throws {
    let old = Address.fixture(id: "old", line: "Старый")
    let created = Address.fixture(id: "created", line: "Новый")
    let service = FakeOrderService(
      fetchResults: [.success([old]), .success([old, created])]
    )
    let store = AddressStore(orderService: service)
    await store.loadIfNeeded()

    let newID = try await store.createAddress(AddressDraft(address: created))

    #expect(newID == created.id)
    #expect(store.selectedAddressID == old.id)
    #expect(await service.createdDrafts == [AddressDraft(address: created)])
  }

  @Test func createFromEmptyListRemainsDraftUntilConfirmation() async throws {
    let created = Address.fixture(id: "created", line: "Новый")
    let service = FakeOrderService(
      fetchResults: [.success([]), .success([created])]
    )
    let store = AddressStore(orderService: service)
    await store.loadIfNeeded()

    let newID = try await store.createAddress(AddressDraft(address: created))

    #expect(newID == created.id)
    #expect(store.selectedAddressID == nil)
    store.confirmSelection(id: created.id)
    #expect(store.selectedAddressID == created.id)
  }

  @Test func updateUsesPUTAndRefreshesAddress() async throws {
    let original = Address.fixture(id: "one", line: "Старый")
    let updated = Address.fixture(id: "one", line: "Новый")
    let service = FakeOrderService(
      fetchResults: [.success([original]), .success([updated])]
    )
    let store = AddressStore(orderService: service)
    await store.loadIfNeeded()

    try await store.updateAddress(
      id: original.id,
      draft: AddressDraft(address: updated)
    )

    #expect(store.addresses == [updated])
    #expect(await service.updatedDrafts.first?.id == original.id)
  }

  @Test func deleteUsesDELETEAndReconcilesSelection() async throws {
    let first = Address.fixture(id: "first", line: "Первый")
    let second = Address.fixture(id: "second", line: "Второй")
    let service = FakeOrderService(
      fetchResults: [.success([first, second]), .success([second])]
    )
    let store = AddressStore(orderService: service)
    await store.loadIfNeeded()

    try await store.deleteAddress(id: first.id)

    #expect(store.addresses == [second])
    #expect(store.selectedAddressID == second.id)
    #expect(await service.deletedIDs == [first.id])
  }
}

private extension Address {
  static func fixture(id: String, line: String) -> Address {
    Address(
      id: id,
      coordinates: .init(longitude: 92.87, latitude: 56.01),
      addressLine: line,
      floor: nil,
      entrance: nil,
      intercomCode: nil,
      comment: nil
    )
  }
}
