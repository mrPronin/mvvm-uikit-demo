//
//  UserDetails+Network+IntegrationTests.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 12.12.22.
//

import Foundation
import XCTest

@testable import mbition_ios

class UserDetailsNetworkIntegrationTests: XCTestCase {
    func testUserDetailsSuccessfulResponse() throws {
        let session = URLSession(mockResponder: UserDetails.Service.MockDataURLResponder.self)
        let publisher = session.publisher(for: .userDetails(with: "user_id"))
        let result = try awaitMany(publisher)
        XCTAssertEqual(result, UserDetails.Model.mockedUserDetails)
    }
    
    func testUserDetailsFailWithBadServerResponse() throws {
        let session = URLSession(mockResponder: MockErrorURLResponder.self)
        let publisher = session.publisher(for: .userDetails(with: "user_id"))
        XCTAssertThrowsError(try awaitMany(publisher))
    }
}
