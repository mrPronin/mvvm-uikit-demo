//
//  UIImage+placeholder.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 08.12.22.
//

import UIKit

extension UIImage {
    static let placeholder = UIImage(systemName: "person", withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
}

