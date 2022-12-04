//
//  UIViewExtension.swift
//  mbition-ios
//
//  Created by Dmitry Kurkin on 24.04.20.
//  Copyright © 2020 Dmitry Kurkin. All rights reserved.
//

import UIKit

public protocol ChainLayoutCompatible {
    associatedtype LayoutBase

    var cl: ChainLayout<LayoutBase> { get }
}

extension UIView: ChainLayoutCompatible {}

public extension ChainLayoutCompatible where Self: UIView {
    var cl: ChainLayout<Self> {
        translatesAutoresizingMaskIntoConstraints = false
        return ChainLayout(self)
    }
    
    func add(into view: UIView) -> ChainLayout<Self> {
        view.addSubview(self)
        return cl
    }
}
