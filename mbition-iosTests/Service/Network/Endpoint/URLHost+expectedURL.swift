//
//  URLHost+expectedURL.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 13.12.22.
//

import Foundation
@testable import mbition_ios
import XCTest

extension URLHost {
    func expectedURL(withPath path: String) throws -> URL {
        let url = URL(string: "https://" + rawValue + "/" + path)
        return try XCTUnwrap(url)
    }
}
