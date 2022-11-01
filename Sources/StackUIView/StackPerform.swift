import RxCocoa
import UIKit

public protocol StackPerform {
    var relateView: UIView? { get }
}

public protocol StackPerformCompatible {}

private var stackviewContext: UInt8 = 0
public extension StackPerformCompatible where Self: UIView {
    var stacked: StackPerforming<Self> {
        return synchronizedBag(self) {
            if let object = objc_getAssociatedObject(self, &stackviewContext) as? StackPerforming<Self>, object.view === self {
                return object
            }
            let object = StackPerforming(view: self)
            objc_setAssociatedObject(self, &stackviewContext, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return object
        }
    }
}

extension UIView: StackPerformCompatible {}
