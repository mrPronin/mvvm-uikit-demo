//
//  Then.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation
import CoreGraphics
import UIKit.UIGeometry

public protocol Then {}

extension Then where Self: AnyObject {
    @inlinable
    public func then(_ block: (Self) throws -> Void) rethrows -> Self {
      try block(self)
      return self
    }
}

extension NSObject: Then {}

extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}

extension Array: Then {}
extension Dictionary: Then {}
extension Set: Then {}
extension JSONDecoder: Then {}
extension JSONEncoder: Then {}

extension UIEdgeInsets: Then {}
extension UIOffset: Then {}
extension UIRectEdge: Then {}

