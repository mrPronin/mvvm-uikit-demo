//
//  String+nilIfEmpty.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 08.12.22.
//

import Foundation

public extension String {
    var nilIfEmpty: String? {
        return self.isEmpty ? nil : self
    }
}
