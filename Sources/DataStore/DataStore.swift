import Cache

/**
 A generic data store class that facilitates data loading, caching, and storing.

 The `DataStore` class is an open class, allowing it to be subclassed and customized based on specific requirements.

 The `DataStore` class also conforms to the ConsumingObservableObject and DataStoring protocols. ConsumingObservableObject signifies that the class can be observed for changes, while DataStoring indicates that the class supports data storing.

 - Note: This data store uses a cache by default and can be subclassed to support different ways of storing data while still leveraging the cache.

 - SeeAlso: `Adaptable`
 - SeeAlso: `DataLoading`
 - SeeAlso: `DataStoring`
 - SeeAlso: `ConsumingObservableObject`
 - SeeAlso: `Identifiable`
 - SeeAlso: `Cache`
 */
open class DataStore<DataLoader: DataLoading>: ConsumingObservableObject, DataStoring where DataLoader.DeviceData.To == DataLoader.DeviceData.StoredValue {

    /// A typealias that represents the type of data loaded by the DataLoader.
    public typealias LoadedData = DataLoader.LoadedData

    /// A typealias that represents the type of data used by the DataLoader
    public typealias DeviceData = DataLoader.DeviceData

    /// A typealias that represents the type of data stored in the data store.
    public typealias StoredData = DataLoader.DeviceData.StoredValue

    /// The cache instance that stores the loaded data.
    open var cache: Cache<DeviceData.ID, DeviceData>

    /// An instance of the `DataLoader` responsible for loading data from a data source.
    public let loader: DataLoader

    /**
     Initializes a new instance of the `DataStore`.

     - Parameters:
        - initalValues: A dictionary of initial values.
        - loader: An object that conforms to `DataLoader`.
        - storedType: The type of the stored data.
     */
    public init(
        initalValues: [DeviceData.ID: DeviceData] = [:],
        loader: DataLoader
    ) {
        self.cache = Cache(initialValues: initalValues)
        self.loader = loader
        
        super.init()
        
        consume(object: cache)
    }

    /**
     Stores the given data in the data store.

     - Parameters:
        - data: The data to store.

     - Throws: An error if the data cannot be stored.

     - Note: This method iterates through the data and sets each value in the cache using its ID as the key.
     */
    open func store(data: [DeviceData]) throws {
        for datum in data {
            cache.set(value: datum, forKey: datum.id)
        }
    }

    /**
     Removes the data with the given IDs from the data store.

     - Parameters:
        - data: The array of IDs of the data to remove.

     - Throws: An error if the data cannot be deleted.

     - Note: This method iterates through the IDs and removes each value from the cache.
     */
    open func delete(data: [DeviceData.ID]) throws {
        for datum in data {
            cache.remove(datum)
        }
    }

    /**
     Fetches all the data stored in the data store.

     - Returns: An array of all the stored data.

     - Note: This method retrieves all the values from the cache and returns them as an array.
     */
    open func fetch() -> [DeviceData] {
        Array(cache.allValues.values)
    }

    /**
     Fetches the data that satisfies the given filter.

     - Parameters:
        - where: A closure that takes a `DeviceData` object and returns a boolean indicating whether to include it in the result.

     - Returns: An array of all the data that satisfies the filter.

     - Note: This method filters the fetched data using the given filter closure and returns the filtered results.
     */
    open func fetch(where filter: (DeviceData) -> Bool) -> [DeviceData] {
        let allValues = fetch()

        let filteredValues = allValues.filter(filter)

        return filteredValues
    }

    /**
     Fetches the data with the given ID.

     - Parameters:
        - id: The ID of the data to fetch.

     - Throws: An error if the data cannot be fetched.

     - Returns: The data with the given ID.

     - Note: This method resolves the ID to the corresponding value in the cache.
     */
    open func fetch(id: DeviceData.ID) throws -> DeviceData {
        try cache.resolve(id, as: DeviceData.self)
    }

    /**
     Loads all the data asynchronously.

     - Throws: An error if the data cannot be loaded.

     - Note: This method uses the data loader to asynchronously load the data and then stores it in the data store.
     */
    open func load() async throws {
        let loadedData: [DeviceData] = try await loader.load()
        
        try await MainActor.run {
            try store(data: loadedData)
        }
    }

    /**
    Loads the data with the given ID asynchronously.

    - Parameters:
       - id: The ID of the data to load.

    - Throws: An error if the data cannot be loaded.

    - Note: This method uses the data loader to asynchronously load the data and then stores it in the data store.
    */
    open func load(id: DeviceData.ID) async throws {
        let loadedData: DeviceData = try await loader.load(id: id)

        try await MainActor.run {
            try store(data: [loadedData])
        }
    }
}

extension DataStore {
    /**
     Accesses the value associated with the given ID for reading and writing.

     - Parameters:
        - id: The ID to retrieve the value for.

     - Returns: The value stored in the `DataStore`'s `Cache` for the given ID, or `nil` if it doesn't exist.

     - Note: If `nil` is assigned to the subscript, then the value is removed from the cache.
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
