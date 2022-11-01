import RxCocoa
import RxSwift

@propertyWrapper
public struct RxDriver<Element> {
    private let subject: BehaviorSubject<Element>

    public var wrappedValue: Element {
        didSet {
            subject.onNext(wrappedValue)
        }
    }

    public var projectedValue: Driver<Element> {
        subject.asDriver(onErrorJustReturn: wrappedValue)
    }

    public init(wrappedValue: Element) {
        self.wrappedValue = wrappedValue
        self.subject = .init(value: wrappedValue)
    }
}

@propertyWrapper
public struct RxDeduplicateDriver<Element: Equatable> {
    private let subject: BehaviorSubject<Element>

    public var wrappedValue: Element {
        didSet {
            if (try? subject.value()) != wrappedValue {
                subject.onNext(wrappedValue)
            }
        }
    }

    public var projectedValue: Driver<Element> {
        subject.asDriver(onErrorJustReturn: wrappedValue)
    }

    public init(wrappedValue: Element) {
        self.wrappedValue = wrappedValue
        self.subject = .init(value: wrappedValue)
    }
}
