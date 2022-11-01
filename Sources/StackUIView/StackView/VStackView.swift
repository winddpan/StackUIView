import UIKit

open class VStackView: UIStackView {
    public enum Alignment {
        case fill
        case leading
        case center
        case trailing

        fileprivate var stackViewAlignment: UIStackView.Alignment {
            switch self {
            case .fill:
                return .fill
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            case .center:
                return .center
            }
        }
    }

    public required init(distribution: UIStackView.Distribution = .fill, alignment: Alignment = .center, spacing: CGFloat = 0, @StackPerformViewBuilder content: () -> [StackPerform]) {
        super.init(frame: .zero)
        let views = content().compactMap { $0.relateView }
        views.forEach { view in
            addArrangedSubview(view)
            if let spacer = view as? Spacer {
                spacer.axis = .vertical
            }
            if let divider = view as? Divider {
                divider.axis = .vertical
            }
        }
        axis = .vertical
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
                spacer.axis = .vertical
            }
            if let divider = view as? Divider {
                divider.axis = .vertical
            }
        }
        axis = .vertical
        self.distribution = distribution
        self.alignment = alignment.stackViewAlignment
        self.spacing = spacing
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
