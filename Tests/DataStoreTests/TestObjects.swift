import DataStore
import SwiftUI

// MARK: - TestLoadedData

struct TestLoadedData: Identifiable {
    struct LoadedColor {
        let red: Double
        let green: Double
        let blue: Double
    }

    enum LoadedEnum: String {
        case WeirdCaseExample
        case inconsistent_example
    }

    let id: String
    let user_name: String
    let color: LoadedColor
    let enumValue: LoadedEnum
}

// MARK: - TestDeviceData

struct TestDeviceData: Identifiable, Adaptable {
    enum DeviceEnum: String, Adaptable {
        case weirdCaseExample
        case inconsistentExample

        init(from: TestLoadedData.LoadedEnum) {
            switch from {
            case .WeirdCaseExample:
                self = .weirdCaseExample
            case .inconsistent_example:
                self = .inconsistentExample
            }
        }
    }

    let id: String
    var userName: String
    var color: Color
    var enumValue: DeviceEnum

    var adapted: TestStoredData {
        TestStoredData(from: self)
    }

    init(id: String, userName: String, color: Color, enumValue: DeviceEnum) {
        self.id = id
        self.userName = userName
        self.color = color
        self.enumValue = enumValue
    }

    init(from: TestLoadedData) {
        self.init(
            id: from.id,
            userName: from.user_name,
            color: Color(
                red: from.color.red,
                green: from.color.green,
                blue: from.color.blue
            ),
            enumValue: DeviceEnum(from: from.enumValue)
        )
    }

    init(stored: TestStoredData) {
        self.init(
            id: stored.id,
            userName: stored.userName,
            color: stored.color,
            enumValue: stored.enumValue
        )
    }
}

// MARK: - StoredData

struct TestStoredData: Adaptable, Identifiable {
    let id: String
    let userName: String
    let color: Color
    let enumValue: TestDeviceData.DeviceEnum

    var adapted: TestDeviceData {
        TestDeviceData(stored: self)
    }

    init(from: TestDeviceData) {
        id = from.id
        userName = from.userName
        color = from.color
        enumValue = from.enumValue
    }
}

// MARK: - TestDataLoader

class TestDataLoader: DataLoading {
    typealias LoadedData = TestLoadedData
    typealias DeviceData = TestDeviceData

    func load() async throws -> [LoadedData] {
        [
            LoadedData(
                id: UUID().uuidString,
                user_name: "blue user",
                color: .init(red: 0, green: 0, blue: 1),
                enumValue: .inconsistent_example
            ),
            LoadedData(
                id: UUID().uuidString,
                user_name: "green user",
                color: .init(red: 0, green: 1, blue: 0),
                enumValue: .inconsistent_example
            ),
            LoadedData(
                id: UUID().uuidString,
                user_name: "red user",
                color: .init(red: 1, green: 0, blue: 0),
                enumValue: .inconsistent_example
            )
        ]
    }

    func load(id: String) async throws -> LoadedData {
        LoadedData(
            id: id,
            user_name: "user \(id)",
            color: .init(red: 0, green: 0, blue: 0),
            enumValue: .inconsistent_example
        )
    }
}
