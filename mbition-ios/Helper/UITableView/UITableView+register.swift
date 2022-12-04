//
//  UITableView+register.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import UIKit

extension UITableView {
    func registerCellClass(_ cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String.className(cellClass))
    }
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        register(viewClass, forHeaderFooterViewReuseIdentifier: String.className(viewClass))
    }
    
    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
