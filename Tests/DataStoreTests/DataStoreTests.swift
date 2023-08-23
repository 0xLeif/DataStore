import SwiftUI
import XCTest
@testable import DataStore

final class DataStoreTests: XCTestCase {
    func testLoadAndFetch() async throws {
        let store = DataStore(loader: TestDataLoader())

        try await store.load()

        let values = await store.fetch()

        XCTAssertEqual(values.count, 3)
    }

    func testLoadIDAndFetch() async throws {
        let store = DataStore(loader: TestDataLoader())

        let expectedID = "some-id"

        try await store.load(id: expectedID)

        let value = try await store.fetch(id: expectedID)

        XCTAssertEqual(value.id, expectedID)
    }

    func testLoadAndFetchWhere() async throws {
        let store = DataStore(loader: TestDataLoader())

        try await store.load()

        let values = await store.fetch { data in
            data.color == Color(red: 0, green: 1, blue: 0)
        }

        XCTAssertEqual(values.count, 1)
    }

    func testStoreAndFetch() async throws {
        let store = DataStore(loader: TestDataLoader())

        let values = await store.fetch()

        XCTAssertEqual(values.count, 0)

        let expectedID = UUID().uuidString
        let expectedUserName = "test"
        let expectedColor = Color.green
        let expectedEnumValue = TestDeviceData.DeviceEnum.weirdCaseExample

        try await store.store(
            data: [
                TestDeviceData(
                    id: expectedID,
                    userName: expectedUserName,
                    color: expectedColor,
                    enumValue: expectedEnumValue
                )
            ]
        )

        let value = try await store.fetch(id: expectedID)

        XCTAssertEqual(value.id, expectedID)
        XCTAssertEqual(value.userName, expectedUserName)
        XCTAssertEqual(value.color, expectedColor)
        XCTAssertEqual(value.enumValue, expectedEnumValue)
    }

    func testDelete() async throws {
        let store = DataStore(loader: TestDataLoader())

        try await store.load()

        let values = await store.fetch()

        XCTAssertEqual(values.count, 3)

        try await store.delete(data: values.map(\.id))

        let fetchCount = await store.fetch().count

        XCTAssertEqual(fetchCount, 0)
    }
}
