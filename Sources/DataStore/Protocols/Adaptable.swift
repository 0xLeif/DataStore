/// A protocol for adapting data from one type to another.
public protocol Adaptable {
    /// The type of data to adapt from.
    associatedtype From

    /// The type of data to adapt to.
    associatedtype To

    /// Initializes an instance by adapting data from the given type.
    /// - Parameter from: The data to adapt from.
    init(from: From)

    /// The adapted data of the specified type.
    var adapted: To { get }
}

extension Adaptable where To == Self {
    /// Returns the instance itself as the adapted data of the same type.
    public var adapted: To { self }
}
