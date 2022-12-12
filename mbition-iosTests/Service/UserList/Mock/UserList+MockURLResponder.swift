//
//  UserList+MockURLResponder.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 12.12.22.
//

import Foundation
@testable import mbition_ios

extension UserList.Service {
    enum MockDataURLResponder: MockURLResponder {
        static func respond(to request: URLRequest) throws -> Data {
            return try JSONEncoder().encode(UserList.Model.mockedUserList)
        }
    }
}
