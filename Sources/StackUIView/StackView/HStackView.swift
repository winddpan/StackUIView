import UIKit

open class HStackView: UIStackView {
    public enum Alignment {
        case fill
        case top
        case center
        case bottom
        case firstBaseline
        case lastBaseline

        fileprivate var stackViewAlignment: UIStackView.Alignment {
            switch self {
            case .fill:
                return .fill
            case .top:
                return .top
            case .firstBaseline:
                return .firstBaseline
            case .center:
                return .center
            case .bottom:
                return .bottom
            case .lastBaseline:
                return .lastBaseline
            }
        }
    }

    public required init(distribution: UIStackView.Distribution = .fill, alignment: Alignment = .center, spacing: CGFloat = 0, @StackPerformViewBuilder content: () -> [StackPerform]) {
        super.init(frame: .zero)
        let views = content().compactMap { $0.relateView }
        views.forEach { view in
            addArrangedSubview(view)
            if let spacer = view as? Spacer {
                spacer.axis = .horizontal
            }
            if let divider = view as? Divider {
                divider.axis = .horizontal
            }
        }
        axis = .horizontal
        self.distribution = distribution
        self.alignment = alignment.stackViewAlignment
        self.spacing = spacing
    }

    public required init(distribution: UIStackView.Distribution = .fill, alignment: Alignment = .center, spacing: CGFloat = 0, @StackViewBuilder content: () -> [UIView]) {
        super.init(frame: .zero)
        let views = content()
        views.forEach { view in
            addArrangedSubview(view)
            if let spacer = view as? Spacer {
                spacer.axis = .horizontal
            }
            if let divider = view as? Divider {
                divider.axis = .horizontal
            }
        }
        axis = .horizontal
        self.distribution = distribution
        self.alignment = alignment.stackViewAlignment
        self.spacing = spacing
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
