//
//  String+className.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String { NSStringFromClass(aClass).components(separatedBy: ".").last! }
}
