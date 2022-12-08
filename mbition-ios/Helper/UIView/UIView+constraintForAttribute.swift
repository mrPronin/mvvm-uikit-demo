//
//  UIView+constraintForAttribute.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 08.12.22.
//

import UIKit

extension UIView {
    func constraint(forAttribute attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if
            attribute == .bottom
                || attribute == .top
                || attribute == .leading
                || attribute == .trailing
        {
            guard let aSuperview = self.superview else {
                return nil
            }
            weak var welf = self
            if let constraint = aSuperview.constraints.first(where: { (constraint) -> Bool in
                guard (constraint.firstItem === welf && constraint.firstAttribute == attribute) || (constraint.secondItem === welf && constraint.secondAttribute == attribute) else {
                    return false
                }
                return true
            }) {
                return constraint
            }
            return nil
        }
        
        if let constraint = self.constraints.first(where: { (constraint) -> Bool in
            if constraint.firstAttribute == attribute || constraint.secondAttribute == attribute {
                return true
            }
            return false
        }) {
            return constraint
        }
        return nil
    }
}
