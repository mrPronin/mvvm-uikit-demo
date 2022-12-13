//
//  EndpointKinds+Stub.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 13.12.22.
//

import Foundation
@testable import mbition_ios

extension EndpointKinds {
    enum Stub: EndpointKind {
        static func prepare(_ request: inout URLRequest, with data: Void) {
            // No-op
        }
    }
}
