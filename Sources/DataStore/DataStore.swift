import Cache

open class DataStore<
    DataLoader: DataLoading,
    StoredData: Adaptable & Identifiable
>: ConsumingObservableObject, DataStoring
where StoredData.From == DataLoader.DeviceData,
      DataLoader.DeviceData.To == StoredData,
      StoredData.To == DataLoader.DeviceData {
    public typealias LoadedData = DataLoader.LoadedData
    public typealias DeviceData = DataLoader.DeviceData
    public typealias StoredData = StoredData
    
    public let cache: Cache<DeviceData.ID, DeviceData>
    public let loader: DataLoader
    
    public init(
        initalValues: [DeviceData.ID: DeviceData] = [:],
        loader: DataLoader,
        storedType: StoredData.Type = StoredData.self
    ) {
        self.cache = Cache(initialValues: initalValues)
        self.loader = loader
        
        super.init()
        
        consume(object: cache)
    }
    
    open func store(data: [DeviceData]) throws {
        for datum in data {
            cache.set(value: datum, forKey: datum.id)
        }
    }
    
    open func delete(data: [DeviceData.ID]) throws {
        for datum in data {
            cache.remove(datum)
        }
    }
    
    open func fetch() -> [DeviceData] {
        Array(cache.allValues.values)
    }

    open func fetch(where filter: (DeviceData) -> Bool) -> [DeviceData] {
        let allValues = fetch()

        let filteredValues = allValues.filter(filter)

        return filteredValues
    }
    
    open func fetch(id: DeviceData.ID) throws -> DeviceData {
        try cache.resolve(id, as: DeviceData.self)
    }
    
    open func load() async throws {
        let loadedData: [DeviceData] = try await loader.load()
        
        try store(data: loadedData)
    }
    
    open func load(id: LoadedData.ID) async throws {
        let loadedData: DeviceData = try await loader.load(id: id)
        
        try store(data: [loadedData])
    }
}

extension DataStore {
    /**
     Accesses the value associated with the given ID for reading and writing.

     - Parameters:
        - id: The ID to retrieve the value for.
     - Returns: The value stored in the `DataStore`'s `Cache` for the given ID, or `nil` if it doesn't exist.
     - Notes: If `nil` is assigned to the subscript, then the value is removed from the cache.
     */
    public subscript(_ id: DeviceData.ID) -> DeviceData? {
        get {
            cache.get(id, as: DeviceData.self)
        }
        set(newValue) {
            guard let newValue = newValue else {
                return cache.remove(id)
            }

            cache.set(value: newValue, forKey: id)
        }
    }

    /**
     Accesses the value associated with the given ID for reading and writing, optionally using a default value if the ID is missing.

     - Parameters:
        - id: The ID to retrieve the value for.
        - default: The default value to be returned if the value is missing.
     - Returns: The value stored in the `DataStore`'s `Cache` for the given ID, or the default value if it doesn't exist.
     */
    public subscript(_ id: DeviceData.ID, default value: DeviceData) -> DeviceData {
        get {
            cache.get(id, as: DeviceData.self) ?? value
        }
        set(newValue) {
            cache.set(value: newValue, forKey: id)
        }
    }
}
