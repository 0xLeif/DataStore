# DataStore

*An extendable data storage solution with built-in caching capabilities.*

## What is DataStore?

`DataStore` is a generic data storage and caching library for Swift. It provides a convenient way to load, cache, and store data in your apps. The `DataStore` class, by default, utilizes a cache to improve data loading performance. However, it can be subclassed to support other data storage mechanisms while still benefiting from the caching capabilities.

## Features

- **Data Loading**: Easily load data from various sources, such as network requests or local databases, by providing a custom `DataLoading` object.
- **Caching**: By default, `DataStore` integrates a caching mechanism to enhance data loading performance. `DataStore` uses [`Cache`](https://github.com/0xLeif/Cache) as its caching solution.
- **Flexible Data Retrieval**: Access loaded data via the `fetch()` method or fetch data based on specific criteria using closure-based filtering.
- **Data Storage**: Store new data objects into the `DataStore` for later retrieval.
- **Data Deletion**: Remove previously stored data objects from the `DataStore`.

## Installation

### Swift Package Manager (SPM)

Add the following line to your Package.swift file in the dependencies array:

```swift
dependencies: [
    .package(url: "https://github.com/0xLeif/DataStore.git", from: "0.1.0")
]
```

## Usage

### Creating a DataStore

To create a `DataStore`, you need to provide a `DataLoading` object. The `DataLoading` object encapsulates the logic to load data from a specific source, such as a network request or local database. You can easily subclass `DataStore` to implement your own data storage mechanism, while still utilizing the caching capabilities.

```swift
let store = DataStore(loader: YourDataLoader())
```

### Loading Data

You can load data into the `DataStore` using the `load()` method. This will asynchronously load the data using the provided data loader.

```swift
try await store.load()
```

You can also load data with a specific identifier using the `load(id:)` method:

```swift
let expectedID = "some-id"
try await store.load(id: expectedID)
```

### Fetching Data

You can fetch the loaded data from the `DataStore` using the `fetch()` method. This will return an array of the loaded data objects.

```swift
let values = store.fetch()
```

You can also fetch data with a specific identifier using the `fetch(id:)` method:

```swift
let expectedID = "some-id"
let value = try store.fetch(id: expectedID)
```

Additionally, you can fetch data that matches specific conditions using the `fetch(where:)` method with a closure:

```swift
let values = store.fetch { data in
    // Condition to filter the data, e.g. data.color == .red
}
```

### Storing Data

You can store new data in the `DataStore` using the `store(data:)` method. This will add the provided data objects to the store.

```swift
try store.store(
    data: [
        YourDataObject(
            // Provide values for your data object properties
        )
    ]
)
```

### Deleting Data

You can delete previously stored data from the `DataStore` using the `delete(data:)` method. This will remove the data objects with the specified identifiers from the store.

## Example

Here are some usage examples to demonstrate how to use the `DataStore` library:

```swift
// Example 1: Loading and fetching data
let store = DataStore(loader: YourDataLoader())
try await store.load()
let values = store.fetch()

// Example 2: Storing and fetching data
let expectedID = "some-id"
try store.store(
    data: [
        YourDataObject(
            id: expectedID,
            // Provide values for your data object properties
        )
    ]
)
let value = try store.fetch(id: expectedID)

// Example 3: Deleting data
try store.delete(data: [value.id])
```

## Contributing

Contributions are welcome! If you encounter any issues, have feature requests, or want to contribute code improvements, please feel free to open an issue or submit a pull request.

## License

DataStore is released under the MIT License. See `LICENSE` for details.
