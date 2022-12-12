//
//  UserDetails+MockURLResponder.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 12.12.22.
//

import Foundation
@testable import mbition_ios

extension UserDetails.Service {
    enum MockDataURLResponder: MockURLResponder {
        static func respond(to request: URLRequest) throws -> Data {
            return try JSONEncoder().encode(UserDetails.Model.mockedUserDetails)
        }
    }
}
