import Foundation
import RxSwift

func synchronizedBag<T>(_ obj: AnyObject, _ action: () -> T) -> T {
    objc_sync_enter(obj)
    let result = action()
    objc_sync_exit(obj)
    return result
}

private var disposeBagContext: UInt8 = 0
func getAutoDisposeBag(_ obj: AnyObject) -> DisposeBag {
    return synchronizedBag(obj) {
        if let disposeObject = objc_getAssociatedObject(obj, &disposeBagContext) as? DisposeBag {
            return disposeObject
        }
        let disposeObject = DisposeBag()
        objc_setAssociatedObject(obj, &disposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return disposeObject
    }
}
