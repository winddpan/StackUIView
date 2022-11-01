//
//  File.swift
//
//
//  Created by PAN on 2022/11/1.
//

import UIKit

extension UIView {
    var widthConstraints: [NSLayoutConstraint] {
        constraints.filter { cons in
            if cons.firstItem === self, cons.firstAttribute == .width {
                return true
            }
            if cons.secondItem === self, cons.secondAttribute == .width {
                return true
            }
            return false
        }
    }

    var heightConstraints: [NSLayoutConstraint] {
        constraints.filter { cons in
            if cons.firstItem === self, cons.firstAttribute == .height {
                return true
            }
            if cons.secondItem === self, cons.secondAttribute == .height {
                return true
            }
            return false
        }
    }

    func removeWidthConstraints() {
        removeConstraints(widthConstraints)
    }

    func removeHeightConstraints() {
        removeConstraints(heightConstraints)
    }
}
