//
//  EndpointTests.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 13.12.22.
//

import Foundation
@testable import mbition_ios
import XCTest

class EndpointTests: XCTestCase {
    typealias StubbedEndpoint = Endpoint<EndpointKinds.Stub, String, String>
    let host = URLHost(rawValue: "test")
    
    func testBasicRequestGeneration() throws {
        let endpoint = StubbedEndpoint(path: "path")
        let request = endpoint.makeRequest(with: (), host: host)
        
        try XCTAssertEqual(request?.url, host.expectedURL(withPath: "path"))
    }
    
    func testUserListEndpoint() throws {
        let paginationRequest = Pagination.Sink<UserList.Model>.Request(since: 30, perPage: 10)
        let endpoint = Endpoint.userListWith(paginationRequest: paginationRequest)
        let request = endpoint.makeRequest(with: (), host: host)
        try XCTAssertEqual(request?.url, host.expectedURL(withPath: "users?per_page=10&since=30"))
        XCTAssertEqual(request?.httpMethod, Network.HTTPMethod.get.rawValue)
        XCTAssertEqual(request?.allHTTPHeaderFields, [
            "Content-Type": "application/json",
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28"
        ])
    }

    func testUserDetailsEndpoint() throws {
        let userId = "user_id"
        let endpoint = Endpoint.userDetails(with: userId)
        let request = endpoint.makeRequest(with: (), host: host)
        try XCTAssertEqual(request?.url, host.expectedURL(withPath: "users/\(userId)"))
        XCTAssertEqual(request?.httpMethod, Network.HTTPMethod.get.rawValue)
        XCTAssertEqual(request?.allHTTPHeaderFields, [
            "Content-Type": "application/json",
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28"
        ])
    }
}
