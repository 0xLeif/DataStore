/// A protocol for loading data asynchronously and adapting it to a desired format using the `Adaptable` protocol.
public protocol DataLoading {
    /// The type of loaded data, which should conform to the `Identifiable` protocol.
    associatedtype LoadedData: Identifiable

    /// The type of device-specific data, which should conform to the `Adaptable` and `Identifiable` protocols, with `From` being the same type as `LoadedData`.
    associatedtype DeviceData: Adaptable & Identifiable where DeviceData.From == LoadedData

    /// Loads an array of `LoadedData` objects asynchronously.
    /// - Returns: An array of loaded data.
    func load() async throws -> [LoadedData]

    /// Loads a single `LoadedData` object with the specified identifier asynchronously.
    /// - Parameter id: The identifier of the data to load.
    /// - Returns: The loaded data.
    func load(id: LoadedData.ID) async throws -> LoadedData
}

extension DataLoading {
    /// Loads an array of `DeviceData` objects asynchronously by adapting and mapping the loaded `LoadedData` objects.
    /// - Returns: An array of loaded device-specific data.
    public func load() async throws -> [DeviceData] {
        let loadedData: [LoadedData] = try await load()
        return loadedData.map(DeviceData.init(from:))
    }

    /// Loads a single `DeviceData` object with the specified identifier asynchronously by adapting the loaded `LoadedData` object.
    /// - Parameter id: The identifier of the data to load.
    /// - Returns: The loaded device-specific data.
    public func load(id: LoadedData.ID) async throws -> DeviceData {
        let loadedData: LoadedData = try await load(id: id)
        return DeviceData(from: loadedData)
    }
}
