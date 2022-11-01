import RxCocoa
import UIKit

public final class StackPerforming<V: UIView>: StackPerform {
    weak var view: V?
    public var relateView: UIView? {
        view
    }

    private weak var widthConstraint: NSLayoutConstraint?
    private weak var heightConstraint: NSLayoutConstraint?

    init(view: V) {
        self.view = view
    }
}

public extension StackPerforming {
    func onReceive<T>(_ driver: Driver<T>, perform action: @escaping (V, T) -> Void) -> Self {
        driver.drive(with: self, onNext: { object, value in
            if let view = object.view {
                action(view, value)
            }
        })
        .disposed(by: getAutoDisposeBag(self))

        return self
    }

    @discardableResult
    func perform(_ action: (V) -> Void) -> Self {
        if let view = view {
            action(view)
        }
        return self
    }

    @discardableResult
    func sizeConstraint(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        guard let view = view else {
            return self
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthConstraint = nil
            if width == .greatestFiniteMagnitude {
                if let superview = view.superview {
                    widthConstraint = view.widthAnchor.constraint(equalTo: superview.widthAnchor)
                }
            } else {
                widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
            }
            widthConstraint?.isActive = true
        }
        if let height = height {
            heightConstraint = nil
            if width == .greatestFiniteMagnitude {
                if let superview = view.superview {
                    heightConstraint = view.heightAnchor.constraint(equalTo: superview.heightAnchor)
                }
            } else {
                heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
            }
            heightConstraint?.isActive = true
        }
        return self
    }
}
