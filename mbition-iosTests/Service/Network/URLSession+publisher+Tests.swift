//
//  URLSession+publisher+Test.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 11.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

class URLSessionPublisherTests: XCTestCase {
    var sut: URLSession!
    var allHeaders: [AnyHashable : Any]!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession.shared
    }
    
    override func tearDownWithError() throws {
        sut = nil
        allHeaders = nil
    }
    
    func testExtractNextSince_LinkHeaderExist_NextExist() throws {
        allHeaders = ["Link" : "<https://api.github.com/users?per_page=20&since=30>; rel=\"next\", <https://api.github.com/users{?since}>; rel=\"first\""]
        let result = sut.extractNextSince(from: allHeaders)
        XCTAssertEqual(result, 30)
    }
    
    func testExtractNextSince_LinkHeaderExist_NextDoesNotExist() throws {
        allHeaders = ["Link" : "<https://api.github.com/users{?since}>; rel=\"first\""]
        let result = sut.extractNextSince(from: allHeaders)
        XCTAssertEqual(result, nil)
    }
    
    func testExtractNextSince_LinkHeaderDoesNotExist() throws {
        allHeaders = ["Fu" : "<https://api.github.com/users{?since}>; rel=\"first\""]
        let result = sut.extractNextSince(from: allHeaders)
        XCTAssertEqual(result, nil)
    }
    
    func testExtractNextSince_LinkHeaderExist_HeaderDoesntContainURL() throws {
        allHeaders = ["Link" : "rel=\"next\", ; rel=\"first\""]
        let result = sut.extractNextSince(from: allHeaders)
        XCTAssertEqual(result, nil)
    }
}
