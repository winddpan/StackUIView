//
//  ViewBox.swift
//  StackUI
//
//  Created by tony on 2021/11/24.
//

import RxCocoa
import UIKit

public struct PaddingEdge: OptionSet {
    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let top: PaddingEdge = .init(rawValue: 1 << 0)
    public static let bottom: PaddingEdge = .init(rawValue: 1 << 1)
    public static let leading: PaddingEdge = .init(rawValue: 1 << 2)
    public static let trailing: PaddingEdge = .init(rawValue: 1 << 3)
    public static let horizontal: PaddingEdge = [.leading, .trailing]
    public static let vertical: PaddingEdge = [.top, .bottom]
    public static let all: PaddingEdge = [.top, .bottom, .leading, .trailing]
}

public extension StackPerforming {
    func padding(_ length: CGFloat) -> StackPerforming<PaddingBoxView> {
        padding(.all, length)
    }

    func padding(_ edges: PaddingEdge, _ length: CGFloat) -> StackPerforming<PaddingBoxView> {
        let box: PaddingBoxView
        if let _box = self.relateView as? PaddingBoxView {
            box = _box
        } else {
            box = PaddingBoxView(view: self.view ?? UIView())
        }

        var paddings = box.paddings
        if edges.contains(.top) {
            paddings.top = length
        }
        if edges.contains(.leading) {
            paddings.left = length
        }
        if edges.contains(.bottom) {
            paddings.bottom = length
        }
        if edges.contains(.trailing) {
            paddings.right = length
        }
        if paddings != box.paddings {
            box.paddings = paddings
        }
        return box.stacked
    }
}

public final class PaddingBoxView: UIView {
    public var view: UIView
    private var _constraints = [NSLayoutConstraint]()

    fileprivate var paddings: UIEdgeInsets = .zero {
        didSet {
            view.translatesAutoresizingMaskIntoConstraints = false
            removeConstraints(_constraints)
            _constraints = [
                view.topAnchor.constraint(equalTo: topAnchor, constant: paddings.top),
                view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddings.bottom),
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddings.left),
                view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddings.right),
            ]
            NSLayoutConstraint.activate(_constraints)
        }
    }

    fileprivate init(view: UIView) {
        self.view = view
        super.init(frame: .zero)
        addSubview(view)
        paddings = .zero
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
