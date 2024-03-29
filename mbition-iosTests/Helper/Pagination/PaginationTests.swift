//
//  PaginationTest.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 09.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

class PaginationTests: XCTestCase {
    typealias PaginationSink = Pagination.Sink<UserList.Model>
    var sut: PaginationSink!
    var uiSource: Pagination.UISource!
    var reloadSubject: PassthroughSubject<Void, Never>!
    var loadNextPageSubject: PassthroughSubject<Void, Never>!
    var subscriptions: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        subscriptions = Set<AnyCancellable>()
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
        subscriptions = []
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
        XCTAssertEqual(result1.count, UserList.Model.mockedUserList.count)
        XCTAssertEqual(result2.count, UserList.Model.mockedUserList.count)
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
        XCTAssertEqual(reloadResult.count, UserList.Model.mockedUserList.count)
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
    
    func testActivityIndicator() throws {
        let activityIndicatorPublisher = sut.activityIndicator
            .collect(2)
            .first()
            .eraseToAnyPublisher()
        
        let result = try awaitMany(activityIndicatorPublisher, actionHandler: { [weak self] in
            self?.reloadSubject.send()
        })
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result, [true, false])
    }
    
    func testDalaLoaderErrorResponse() throws {
        sut = Pagination.Sink(ui: uiSource, loadData: dataLoaderErrorResponse(request:))
        XCTAssert(sut.hasMore)
        let result = try awaitSingle(sut.error, actionHandler: { [weak self] in
            self?.loadNextPageSubject.send()
        })
        XCTAssertTrue(result is Network.Errors, "Unexpected error type: \(type(of: result))")
        XCTAssertEqual(result as? Network.Errors, .notFound)
    }
    
    func dataLoaderNormalResponse(request: PaginationSink.Request) -> AnyPublisher<PaginationSink.Response, Error> {
        return Just<[UserList.Model]>(UserList.Model.mockedUserList)
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
    
    func dataLoaderErrorResponse(request: PaginationSink.Request) -> AnyPublisher<PaginationSink.Response, Error> {
        return Fail(error: Network.Errors.notFound).eraseToAnyPublisher()
    }
}
