import XCTest
@testable import DataStore

final class DataStoreSubscriptTests: XCTestCase {
    func testGet() async throws {
        let store = DataStore(loader: TestDataLoader())

        try await store.load()

        let values = store.fetch()

        XCTAssertEqual(values.count, 3)

        let valueID = try XCTUnwrap(values.first?.id)

        let value = store[valueID]

        XCTAssertNotNil(value)
    }

    func testSet() async throws {
        let store = DataStore(loader: TestDataLoader())

        try await store.load()

        let values = store.fetch()

        XCTAssertEqual(values.count, 3)

        let valueID = try XCTUnwrap(values.first?.id)

        store[valueID]?.userName = "NEW"

        let value = try XCTUnwrap(store[valueID])

        XCTAssertEqual(value.userName, "NEW")
    }

    func testSetRemove() async throws {
        let store = DataStore(loader: TestDataLoader())

        try await store.load()

        let values = store.fetch()

        XCTAssertEqual(values.count, 3)

        let valueID = try XCTUnwrap(values.first?.id)

        store[valueID] = nil

        XCTAssertNil(store[valueID])
    }

    func testGetDefault() async throws {
        let store = DataStore(loader: TestDataLoader())

        try await store.load()

        let values = store.fetch()

        XCTAssertEqual(values.count, 3)

        let valueID = "Invalid ID"
        let defaultValue = TestDeviceData(
            id: "default",
            userName: "default",
            color: .clear,
            enumValue: .inconsistentExample
        )

        let value = store[valueID, default: defaultValue]

        XCTAssertEqual(value.id, defaultValue.id)
    }

    func testSetDefault() async throws {
        let store = DataStore(loader: TestDataLoader())

        try await store.load()

        let values = store.fetch()

        XCTAssertEqual(values.count, 3)

        let valueID = "Invalid ID"
        let defaultValue = TestDeviceData(
            id: "default",
            userName: "default",
            color: .clear,
            enumValue: .inconsistentExample
        )

        store[valueID, default: defaultValue].userName = "NEW"

        let value = try XCTUnwrap(store[valueID])

        XCTAssertNotEqual(value.id, valueID)

        XCTAssertEqual(value.id, defaultValue.id)
        XCTAssertEqual(value.userName, "NEW")
        XCTAssertEqual(value.color, defaultValue.color)
        XCTAssertEqual(value.enumValue, defaultValue.enumValue)
    }
}
