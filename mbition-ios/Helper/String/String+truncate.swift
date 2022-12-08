//
//  String+truncate.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 08.12.22.
//

import Foundation

public extension String {
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }
}
