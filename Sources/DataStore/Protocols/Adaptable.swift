public protocol Adaptable {
    associatedtype From
    associatedtype To

    init(from: From)

    var adapted: To { get }
}

extension Adaptable where To == Self {
    public var adapted: To { self }
}
