import RxCocoa
import RxSwift
import UIKit

public final class LazyBoxView<T: UIView>: UIView {
    var contentView: T?
    let content: () -> T
    
    private var loader: Disposable?
    
    deinit {
        print("lazy deinit")
    }
    
    public init(whenLoad: Driver<Bool>, content: @escaping (() -> T)) {
        self.content = content
        super.init(frame: .zero)
        self.backgroundColor = nil
        self.isHidden = true

        self.loader = whenLoad
            .filter { $0 }
            .drive(with: self, onNext: { `self`, _ in
                self.isHidden = false
                self.loader = nil
            })
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        contentView?.intrinsicContentSize ?? .zero
    }
    
    override public var isHidden: Bool {
        didSet {
            if !isHidden, contentView == nil {
                DispatchQueue.main.async {
                    let contentView = self.content()
                    self.contentView = contentView
                    self.addSubview(contentView)
                    contentView.translatesAutoresizingMaskIntoConstraints = false
                    contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                    contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                    contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                    contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                    
                    self.contentViewObserve()
                    self.invalidateIntrinsicContentSize()
                }
            }
        }
    }
    
    private func contentViewObserve() {
        guard let contentView = contentView else { return }
        
        Observable.combineLatest(contentView.rx.observe(Bool.self, "hidden"),
                                 contentView.rx.observe(Bool.self, "alpha"))
            .asDriver(onErrorJustReturn: (nil, nil))
            .drive(onNext: { [weak self, weak contentView] _ in
                guard let self = self, let contentView = contentView else { return }
                self.isHidden = contentView.isHidden || contentView.alpha <= 0
            })
            .disposed(by: getAutoDisposeBag(self))
    }
    
    override public func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        if subview === contentView {
            removeFromSuperview()
        }
    }
}
