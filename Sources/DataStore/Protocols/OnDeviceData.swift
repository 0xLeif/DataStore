/**
 A protocol that represents on-device data that can be adapted and identified.

 The `OnDeviceData` protocol requires conforming types to be adaptable and identifiable.
 The associated type `StoredValue` represents the type of data that is stored on the device.

 Conforming types must provide an initializer that takes in `stored` data of type `StoredValue`.
 */
public protocol OnDeviceData: Adaptable, Identifiable {
    associatedtype StoredValue: Adaptable where StoredValue.From == Self

    /**
     Initializes an `OnDeviceData` instance with stored data of type `StoredValue`.

     - Parameter stored: The stored data used to initialize the `OnDeviceData` instance.
     */
    init(stored: StoredValue)
}

extension OnDeviceData where StoredValue == To {
    public var adapted: StoredValue {
        To(from: self)
    }
}
