/// A protocol for storing and managing data.
public protocol DataStoring {
    /// The type of data to be stored, which should conform to the `Adaptable` protocol, where `To` is the same type as `DeviceData`.
    associatedtype StoredData: StorableData where StoredData.To == DeviceData

    /// The type of device-specific data, which should conform to the `Adaptable` and `Identifiable` protocols, with `From` being the same type as `StoredData` and `To` being the same type as `StoredData`.
    associatedtype DeviceData: OnDeviceData where StoredData.From == DeviceData, DeviceData.To == StoredData

    /// Stores an array of `DeviceData` objects.
    /// - Parameter data: The data to store or update.
    func store(data: [DeviceData]) async throws

    /// Deletes an array of `DeviceData` objects based on their identifiers.
    /// - Parameter data: The identifiers of the data to delete.
    func delete(data: [DeviceData.ID]) async throws

    /// Fetches all stored `DeviceData` objects.
    /// - Returns: An array of fetched device-specific data.
    func fetch() async -> [DeviceData]

    /// Fetches stored `DeviceData` objects that satisfy the given filter predicate.
    /// - Parameter where: A closure that takes a `DeviceData` object and returns a Boolean value indicating whether the object should be included in the result.
    /// - Returns: An array of fetched device-specific data that pass the filter.
    func fetch(where filter: (DeviceData) -> Bool) async -> [DeviceData]

    /// Fetches a single stored `DeviceData` object based on its identifier.
    /// - Parameter id: The identifier of the data to fetch.
    /// - Returns: The fetched device-specific data.
    /// - Throws: An error if the data could not be found.
    func fetch(id: DeviceData.ID) async throws -> DeviceData
}
