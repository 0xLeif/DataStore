import Combine

/// An `ObservableObject` that can consume and observe changes in other `ObservableObject` instances.
open class ConsumingObservableObject: ObservableObject {
    private var bag: Set<AnyCancellable> = Set()

    deinit {
        bag.removeAll()
    }

    /// Consume changes from the specified `ObservableObject` instance.
    ///
    /// - Parameter object: The `ObservableObject` to consume.
    public func consume<Object: ObservableObject>(
        object: Object
    ) where ObjectWillChangePublisher == ObservableObjectPublisher {
        bag.insert(
            object.objectWillChange.sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    self?.objectWillChange.send()
                }
            )
        )
    }
}
