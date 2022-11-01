import RxCocoa
import UIKit

public protocol UIViewPerform {}

public extension UIViewPerform where Self: UIView {
    func onReceive<T>(_ driver: Driver<T>, perform action: @escaping (Self, T) -> Void) -> Self {
        driver.drive(with: self, onNext: { object, value in
            action(object, value)
        })
        .disposed(by: getAutoDisposeBag(self))

        return self
    }

    @inlinable
    @discardableResult
    func perform(_ action: (Self) -> Void) -> Self {
        action(self)
        return self
    }

    @discardableResult
    func sizeConstraint(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            removeWidthConstraints()
            if width == .greatestFiniteMagnitude {
                if let superview = superview {
                    widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
                }
            } else {
                widthAnchor.constraint(equalToConstant: width).isActive = true
            }
        }
        if let height = height {
            removeHeightConstraints()
            if width == .greatestFiniteMagnitude {
                if let superview = superview {
                    heightAnchor.constraint(equalTo: superview.heightAnchor).isActive = true
                }
            } else {
                heightAnchor.constraint(equalToConstant: height).isActive = true
            }
        }
        return self
    }
}

extension UIView: UIViewPerform {}
