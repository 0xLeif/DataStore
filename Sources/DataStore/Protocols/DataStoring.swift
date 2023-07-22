public protocol DataStoring {
    associatedtype StoredData: Adaptable & Identifiable where StoredData.To == DeviceData
    associatedtype DeviceData: Adaptable & Identifiable where StoredData.From == DeviceData, DeviceData.To == StoredData

    func store(data: [DeviceData]) throws
    func delete(data: [DeviceData.ID]) throws

    func fetch() -> [DeviceData]
    func fetch(where filter: (DeviceData) -> Bool) -> [DeviceData]
    func fetch(id: DeviceData.ID) throws -> DeviceData
}
