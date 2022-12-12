//
//  UserList+Network+IntegrationTests.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 12.12.22.
//

import Foundation
import XCTest

@testable import mbition_ios

class UserListNetworkIntegrationTests: XCTestCase {
    typealias PaginationSink = Pagination.Sink<UserList.Model>
    func testUserListSuccessfulResponse() throws {
        let session = URLSession(mockResponder: UserList.Service.MockDataURLResponder.self)
        let paginationRequest = PaginationSink.Request(since: 0)
        let publisher = session.publisherWith(
            paginationRequest: paginationRequest,
            for: .userListWithPagination
        )
        let result = try awaitMany(publisher)
        XCTAssertEqual(result.data, UserList.Model.mockedUserList)
    }
    func testUserListFailWithBadServerResponse() throws {
        let session = URLSession(mockResponder: MockErrorURLResponder.self)
        let paginationRequest = PaginationSink.Request(since: 0)
        let publisher = session.publisherWith(
            paginationRequest: paginationRequest,
            for: .userListWithPagination
        )
        XCTAssertThrowsError(try awaitMany(publisher))
    }
}
