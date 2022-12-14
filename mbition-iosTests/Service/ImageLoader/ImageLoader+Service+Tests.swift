//
//  ImageLoader+Service.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 14.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

class ImageLoaderServiceTests: XCTestCase {
    var sut: ImageLoader.Service.Implementation!
    var cache: Cache.Service.InMemory<URL, UIImage>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        cache = .init(costProvider: UIImage.estimatedSize)
        sut = ImageLoader.Service.Implementation(cache: cache)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        cache = nil
    }
    
    func testImageLoaderInitWithDefaults() throws {
        XCTAssertNoThrow(sut)
        XCTAssertNotNil(sut)
    }
}

