public protocol DataLoading {
    associatedtype LoadedData: Identifiable
    associatedtype DeviceData: Adaptable & Identifiable where DeviceData.From == LoadedData

    func load() async throws -> [LoadedData]
    func load(id: LoadedData.ID) async throws -> LoadedData
}

extension DataLoading {
    public func load() async throws -> [DeviceData] {
        let loadedData: [LoadedData] = try await load()
        return loadedData.map(DeviceData.init(from:))
    }

    public func load(id: LoadedData.ID) async throws -> DeviceData {
        let loadedData: LoadedData = try await load(id: id)
        return DeviceData(from: loadedData)
    }
}
