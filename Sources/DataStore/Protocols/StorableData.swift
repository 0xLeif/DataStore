/**
 A protocol that represents storable data that can be adapted into `OnDeviceData`.

 The `StorableData` protocol requires conforming types to be adaptable, identifiable, and represent data that can be stored on a device.
 The generic type `To` represents the type that conforms to the `OnDeviceData` protocol and will be used to store the current data.

 Conforming types must ensure that the `To` generic type conforms to the `OnDeviceData` protocol and that its `StoredValue` type is the same as the current data type.
 */
public protocol StorableData: Adaptable where To: OnDeviceData, To.StoredValue == Self { }

extension StorableData {
    public var adapted: To {
        To(stored: self)
    }
}
