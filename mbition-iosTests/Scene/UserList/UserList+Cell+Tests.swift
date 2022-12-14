//
//  UserList+Cell+Tests.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 14.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

class UserListCellTests: XCTestCase {
    var sut: UserList.Cell!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = UserList.Cell()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testInstantiate() throws {
        XCTAssertNotNil(sut)
    }
}
