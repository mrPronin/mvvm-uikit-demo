//
//  Then+Tests.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 14.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

class ThenTests: XCTestCase {
    func testThen_NSObject() {
        let queue = OperationQueue().then {
          $0.name = "awesome"
          $0.maxConcurrentOperationCount = 5
        }
        XCTAssertEqual(queue.name, "awesome")
        XCTAssertEqual(queue.maxConcurrentOperationCount, 5)
      }
}
