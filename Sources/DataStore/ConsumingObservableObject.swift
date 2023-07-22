import Combine

open class ConsumingObservableObject: ObservableObject {
    private var bag: Set<AnyCancellable> = Set()

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
