//
//  UserList+ViewModel+Tests.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 14.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

class UserListViewModelTests: XCTestCase {
    var sut: UserListViewModel!
    var userListService: UserList.Service.Mock!
    var loadSubject: PassthroughSubject<Void, Never>!
    var loadNextPageSubject: PassthroughSubject<Void, Never>!
    var subscriptions: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        userListService = UserList.Service.Mock()
        sut = UserList.ViewModel.Implementation(userListService: userListService)
        loadSubject = PassthroughSubject<Void, Never>()
        loadNextPageSubject = PassthroughSubject<Void, Never>()
        subscriptions = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        userListService = nil
        sut = nil
        loadSubject = nil
        loadNextPageSubject = nil
        subscriptions = []
    }
    
    func testReloadWithSuccessfulResponse() throws {
        userListService.userList = UserList.Model.mockedUserList
        let output = sut.transform(input: .init(
            load: loadSubject.eraseToAnyPublisher(),
            loadNextPage: loadNextPageSubject.eraseToAnyPublisher()
        ))
        let result = try awaitSingle(output.userList, actionHandler: { [weak self] in
            self?.loadSubject.send()
        })
        XCTAssertEqual(result, UserList.Model.mockedUserList)
    }
    
    func testReloadWithUnauthorizedError() throws {
        userListService.error = Network.Errors.unauthorized
        let output = sut.transform(input: .init(
            load: loadSubject.eraseToAnyPublisher(),
            loadNextPage: loadNextPageSubject.eraseToAnyPublisher()
        ))
        output.userList.sink { _ in }.store(in: &subscriptions)
        let result = try awaitSingle(output.error, actionHandler: { [weak self] in
            self?.loadSubject.send()
        })
        XCTAssertTrue(result is Network.Errors, "Unexpected error type: \(type(of: result))")
        XCTAssertEqual(result as? Network.Errors, .unauthorized)
    }
    
    func testLoadNextPageWithSuccessfulResponse() throws {
        userListService.userList = UserList.Model.mockedUserList
        let output = sut.transform(input: .init(
            load: loadSubject.eraseToAnyPublisher(),
            loadNextPage: loadNextPageSubject.eraseToAnyPublisher()
        ))
        let reloadResult = try awaitSingle(output.userList, actionHandler: { [weak self] in
            self?.loadSubject.send()
        })
        XCTAssertEqual(reloadResult.count, UserList.Model.mockedUserList.count)
        XCTAssertEqual(reloadResult, UserList.Model.mockedUserList)
        let loadNextPageResult = try awaitSingle(output.userList, actionHandler: { [weak self] in
            self?.loadNextPageSubject.send()
        })
        XCTAssertEqual(loadNextPageResult.count, UserList.Model.mockedUserList.count * 2)
    }
    
    func testLoadNextPageWithUnauthorizedError() throws {
        userListService.userList = UserList.Model.mockedUserList
        let output = sut.transform(input: .init(
            load: loadSubject.eraseToAnyPublisher(),
            loadNextPage: loadNextPageSubject.eraseToAnyPublisher()
        ))
        let reloadResult = try awaitSingle(output.userList, actionHandler: { [weak self] in
            self?.loadSubject.send()
        })
        XCTAssertEqual(reloadResult.count, UserList.Model.mockedUserList.count)
        XCTAssertEqual(reloadResult, UserList.Model.mockedUserList)
        userListService.error = Network.Errors.unauthorized
        let loadNextPageResult = try awaitSingle(output.error, actionHandler: { [weak self] in
            self?.loadNextPageSubject.send()
        })
        XCTAssertTrue(loadNextPageResult is Network.Errors, "Unexpected error type: \(type(of: loadNextPageResult))")
        XCTAssertEqual(loadNextPageResult as? Network.Errors, .unauthorized)
    }
    
    func testActivityIndicatorWithReload() throws {
        userListService.userList = UserList.Model.mockedUserList
        let output = sut.transform(input: .init(
            load: loadSubject.eraseToAnyPublisher(),
            loadNextPage: loadNextPageSubject.eraseToAnyPublisher()
        ))
        output.userList.sink { _ in }.store(in: &subscriptions)

        let activityIndicatorPublisher = output.activityIndicator
            .collect(2)
            .first()
            .eraseToAnyPublisher()
        
        let result = try awaitSingle(activityIndicatorPublisher, actionHandler: { [weak self] in
            self?.loadSubject.send()
        })
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result, [true, false])
    }
    
    func testActivityIndicatorWithLoadNextPage() throws {
        userListService.userList = UserList.Model.mockedUserList
        let output = sut.transform(input: .init(
            load: loadSubject.eraseToAnyPublisher(),
            loadNextPage: loadNextPageSubject.eraseToAnyPublisher()
        ))
        output.userList.sink { _ in }.store(in: &subscriptions)

        let activityIndicatorPublisher = output.activityIndicator
            .collect(2)
            .first()
            .eraseToAnyPublisher()
        
        let result = try awaitSingle(activityIndicatorPublisher, actionHandler: { [weak self] in
            self?.loadNextPageSubject.send()
        })
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result, [true, false])
    }
}
