import UIKit
open class ZStackView: UIView {
    public enum Alignment {
        case leading
        case trailing
        case top
        case bottom
        case center

        fileprivate var stackViewAlignment: UIStackView.Alignment {
            switch self {
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            case .top:
                return .top
            case .bottom:
                return .bottom
            case .center:
                return .center
            }
        }
    }

    public var alignment: Alignment {
        didSet {
            if alignment != oldValue {
                subviews.forEach { view in
                    removeConstraints(constraints.filter { $0.firstItem === view || $0.secondItem === view })
                }
                setNeedsLayout()
            }
        }
    }

    public required init(alignment: Alignment = .center, @StackViewBuilder content: () -> [UIView]) {
        self.alignment = alignment
        super.init(frame: .zero)

        let views = content()
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }

    public required init?(coder: NSCoder) {
        self.alignment = .center
        super.init(coder: coder)
    }

    override open var intrinsicContentSize: CGSize {
        var size: CGSize = .zero
        subviews.forEach { view in
            if !view.isHidden, view.alpha > 0 {
                var intrinsicContentSize = view.systemLayoutSizeFitting(.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
                if intrinsicContentSize.width == .greatestFiniteMagnitude || intrinsicContentSize.height == .greatestFiniteMagnitude {
                    intrinsicContentSize = view.intrinsicContentSize
                }
                size.width = max(size.width, intrinsicContentSize.width)
                size.height = max(size.height, intrinsicContentSize.height)
            }
        }
        return size
    }

    open func addArrangedSubview(_ view: UIView) {
        addSubview(view)
        setNeedsLayout()
    }

    open func removeArrangedSubview(_ view: UIView) {
        if subviews.contains(where: { $0 === view }) {
            view.removeFromSuperview()
            setNeedsLayout()
        }
    }

    open func insertArrangedSubview(at stackIndex: Int, view: () -> UIView) {
        insertSubview(view(), at: stackIndex)
        setNeedsLayout()
    }

    override open func layoutSubviews() {
        if superview != nil {
            let size = intrinsicContentSize
            if widthConstraints.first?.constant != size.width || heightConstraints.first?.constant != size.height {
                removeWidthConstraints()
                removeHeightConstraints()
                widthAnchor.constraint(equalToConstant: size.width).isActive = true
                heightAnchor.constraint(equalToConstant: size.height).isActive = true
            }

            subviews.forEach { view in
                if constraints.filter({ $0.firstItem === view || $0.secondItem === view }).isEmpty {
                    view.translatesAutoresizingMaskIntoConstraints = false
                    switch alignment {
                    case .leading:
                        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                    case .top:
                        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
                        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                    case .trailing:
                        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
                        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                    case .bottom:
                        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                    case .center:
                        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                    }
                }
            }
        }
        super.layoutSubviews()
    }
}
