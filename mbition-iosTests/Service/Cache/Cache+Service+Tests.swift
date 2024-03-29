//
//  Cache+Service+Tests.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 14.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

class CacheServiceTests: XCTestCase {
    var sut: Cache.Service.InMemory<URL, UIImage>!
    var testImage: UIImage!
    var testURL: URL!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = .init(costProvider: UIImage.estimatedSize)
        testImage = getTestImageWith(height: 10, with: 10, color: .red)!
        testURL = URL(string: "https://example.com/test_image")!
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        testImage = nil
        testURL = nil
    }
    
    func testCacheInitWithDefaultConfig() throws {
        XCTAssertNoThrow(sut)
        XCTAssertNotNil(sut)
    }
    
    func testInsertAndGetValueForKey() throws {
        XCTAssertNil(sut.value(forKey: testURL))
        sut.insert(testImage, forKey: testURL)
        let result = sut.value(forKey: testURL)
        XCTAssertEqual(result, testImage)
    }
    
    func testRemoveValueForKey() throws {
        XCTAssertNil(sut.value(forKey: testURL))
        sut.insert(testImage, forKey: testURL)
        let result = sut.value(forKey: testURL)
        XCTAssertEqual(result, testImage)
        sut.remove(forKey: testURL)
        XCTAssertNil(sut.value(forKey: testURL))
    }
    
    func testRemoveAll() throws {
        XCTAssertNil(sut.value(forKey: testURL))
        sut.insert(testImage, forKey: testURL)
        XCTAssertEqual(sut.value(forKey: testURL), testImage)
        sut.removeAll()
        XCTAssertNil(sut.value(forKey: testURL))
    }
    
    func testSubscript() throws {
        XCTAssertNil(sut[testURL])
        sut[testURL] = testImage
        XCTAssertEqual(sut[testURL], testImage)
        sut[testURL] = nil
        XCTAssertNil(sut[testURL])
    }
    
    // MARK: - Helper
    func getTestImageWith(height: CGFloat, with: CGFloat, color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: with, height: height)
        UIGraphicsBeginImageContext(rect.size)
        color.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
