//
//  PaginationTest.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 09.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

class PaginationTest: XCTestCase {
    typealias PaginationSink = Pagination.Sink<UserList.Model>
    var sut: PaginationSink!
    var uiSource: Pagination.UISource!
    var reloadSubject: PassthroughSubject<Void, Never>!
    var loadNextPageSubject: PassthroughSubject<Void, Never>!
    var subsciptions: Set<AnyCancellable>!
    
    func dataLoaderNormalResponse(request: PaginationSink.Request) -> AnyPublisher<PaginationSink.Response, Error> {
        return Just<[UserList.Model]>(userList)
            .setFailureType(to: Error.self)
            .map { PaginationSink.Response(data: $0, since: request.since, nextSince: request.since + Pagination.perPage) }
            .eraseToAnyPublisher()
    }
    
    func dataLoaderEmptyResponse(request: PaginationSink.Request) -> AnyPublisher<PaginationSink.Response, Error> {
        return Just<[UserList.Model]>([])
            .setFailureType(to: Error.self)
            .map { PaginationSink.Response(data: $0, since: request.since, nextSince: request.since + Pagination.perPage) }
            .eraseToAnyPublisher()
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        subsciptions = Set<AnyCancellable>()
        reloadSubject = PassthroughSubject<Void, Never>()
        loadNextPageSubject = PassthroughSubject<Void, Never>()
        uiSource = Pagination.UISource(
            reload: reloadSubject.eraseToAnyPublisher(),
            loadNextPage: loadNextPageSubject.eraseToAnyPublisher()
        )
        sut = Pagination.Sink(ui: uiSource, loadData: dataLoaderNormalResponse(request:))
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        uiSource = nil
        reloadSubject = nil
        loadNextPageSubject = nil
        subsciptions = []
    }
    
    func testReload() throws {
        XCTAssert(sut.pages.count == 0)
        let result = try awaitSingle(sut.elements, actionHandler: { [weak self] in
            self?.reloadSubject.send()
        })
        
        XCTAssertTrue(!result.isEmpty)
        XCTAssert(sut.pages.count == 1)
        XCTAssert(sut.pages.first?.key == 0)
    }
    
    func testReloadAlwaysReturnFirstPage() throws {
        let result1 = try awaitSingle(sut.elements, actionHandler: { [weak self] in
            self?.reloadSubject.send()
        })
        let result2 = try awaitSingle(sut.elements, actionHandler: { [weak self] in
            self?.reloadSubject.send()
        })
        XCTAssertEqual(result1.count, userList.count)
        XCTAssertEqual(result2.count, userList.count)
        XCTAssertEqual(result1, result2)
        XCTAssert(sut.pages.count == 1)
        XCTAssert(sut.pages.first?.key == 0)
    }
    
    func testLoadNextPage() throws {
        // Initial state, pagination sink cache is empty
        XCTAssert(sut.pages.count == 0)
        let reloadResult = try awaitSingle(sut.elements, actionHandler: { [weak self] in
            self?.reloadSubject.send()
        })
        // Check if first page loaded
        XCTAssertEqual(reloadResult.count, userList.count)
        XCTAssert(sut.pages.count == 1)
        XCTAssert(sut.pages.first?.key == 0)
        
        let secondPageResult = try awaitSingle(sut.elements, actionHandler: { [weak self] in
            self?.loadNextPageSubject.send()
        })
        // Check if first and second pages are loaded
        XCTAssertEqual(secondPageResult.count, Pagination.perPage * 2)
        XCTAssert(sut.pages.count == 2)
    }
    
    func testHasMoreNormalResponse() throws {
        // Initial state, pagination sink cache is empty
        XCTAssert(sut.hasMore)
        let _ = try awaitSingle(sut.elements, actionHandler: { [weak self] in
            self?.reloadSubject.send()
        })
        XCTAssert(sut.hasMore)
    }
    
    func testHasMoreEmptyResponse() throws {
        sut = Pagination.Sink(ui: uiSource, loadData: dataLoaderEmptyResponse(request:))
        XCTAssert(sut.hasMore)
        let _ = try awaitSingle(sut.elements, actionHandler: { [weak self] in
            self?.loadNextPageSubject.send()
        })
        XCTAssert(!sut.hasMore)
    }

    var userList: [UserList.Model] {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "user-list", ofType: "json")!
        let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        var userList: [UserList.Model] = []
        do {
            userList = try JSONDecoder().decode([UserList.Model].self, from: data!)
        } catch {
            LOG(error)
        }
        return userList
    }
}
