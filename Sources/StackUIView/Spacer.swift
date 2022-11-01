import UIKit

open class Spacer: UIView {
    private var _constraints = [NSLayoutConstraint]()

    public var spacing: CGFloat {
        didSet {
            update()
            invalidateIntrinsicContentSize()
        }
    }

    var axis: NSLayoutConstraint.Axis? {
        didSet {
            update()
        }
    }

    public init(_ spacing: CGFloat = 0) {
        self.spacing = spacing
        super.init(frame: .zero)
        backgroundColor = nil
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open var intrinsicContentSize: CGSize {
        switch axis {
        case .horizontal:
            return .init(width: spacing, height: 1)
        case .vertical:
            return .init(width: 1, height: spacing)
        default:
            return .zero
        }
    }

    private func update() {
        if let superview = superview {
            translatesAutoresizingMaskIntoConstraints = false
            removeConstraints(_constraints)

            switch axis {
            case .horizontal:
                _constraints = [
                    heightAnchor.constraint(equalTo: superview.heightAnchor),
                    widthAnchor.constraint(equalToConstant: spacing)
                ]
            case .vertical:
                _constraints = [
                    widthAnchor.constraint(equalTo: superview.widthAnchor),
                    heightAnchor.constraint(equalToConstant: spacing)
                ]
            default:
                _constraints = []
            }
            NSLayoutConstraint.activate(_constraints)
        }
    }
}
