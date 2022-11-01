import UIKit

open class Divider: UIView {
    public var weight: CGFloat {
        didSet {
            update()
        }
    }

    public var color: UIColor = .lightGray {
        didSet {
            update()
        }
    }

    var axis: NSLayoutConstraint.Axis? {
        didSet {
            update()
        }
    }

    public init(weight: CGFloat = 1.0 / UIScreen.main.scale, color: UIColor = .lightGray) {
        self.weight = weight
        self.color = color
        super.init(frame: .zero)
        update()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        update()
    }

    private func update() {
        guard let superview = superview else {
            return
        }
        backgroundColor = color
        translatesAutoresizingMaskIntoConstraints = false
        removeWidthConstraints()
        removeHeightConstraints()
        switch axis {
        case .horizontal:
            widthAnchor.constraint(equalToConstant: weight).isActive = true
            heightAnchor.constraint(equalTo: superview.heightAnchor).isActive = true
        case .vertical:
            widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: weight).isActive = true
        default:
            break
        }
    }
}
