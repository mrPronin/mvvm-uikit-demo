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
    var subsciptions: Set<AnyCancellable>!
    
    func dataLoader(request: PaginationSink.Request) -> AnyPublisher<PaginationSink.Response, Error> {
        return Just<[UserList.Model]>(userList)
            .setFailureType(to: Error.self)
            .map { PaginationSink.Response(data: $0, since: request.since, nextSince: request.since + Pagination.perPage) }
            .eraseToAnyPublisher()
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        subsciptions = Set<AnyCancellable>()
        reloadSubject = PassthroughSubject<Void, Never>()
        uiSource = Pagination.UISource(
            reload: reloadSubject.eraseToAnyPublisher(),
            loadNextPage: Empty().eraseToAnyPublisher(),
            subscriptions: subsciptions
        )
        sut = Pagination.Sink(ui: uiSource, loadData: dataLoader(request:))
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        uiSource = nil
        reloadSubject = nil
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
