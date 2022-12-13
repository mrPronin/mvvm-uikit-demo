//
//  UserDetails+ViewModel+Tests.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 13.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

class UserDetailsViewModelTests: XCTestCase {
    var sut: UserDetailsViewModel!
    var userDetailService: UserDetails.Service.Mock!
    var subsciptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        userDetailService = UserDetails.Service.Mock()
        let userListModel = UserList.Model.mockedUserList[0]
        sut = UserDetails.ViewModel.Implementation(
            userDetailsService: userDetailService,
            userListModel: userListModel
        )
        subsciptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        userDetailService = nil
        subsciptions = []
    }
    
    func testUserDetailsWithSuccessResponse() throws {
        userDetailService.userDetails = UserDetails.Model.mockedUserDetails
        let load = PassthroughSubject<Void, Never>()
        let output = sut.transform(input: .init(load: load.eraseToAnyPublisher()))
        let result = try awaitSingle(output.userDetails, actionHandler: {
            load.send()
        })
        XCTAssertEqual(result, UserDetails.Model.mockedUserDetails)
    }
    
    func testUserDetailsWithUnauthorizedError() throws {
        userDetailService.error = Network.Errors.unauthorized
        let load = PassthroughSubject<Void, Never>()
        let output = sut.transform(input: .init(load: load.eraseToAnyPublisher()))
        output.userDetails.sink { _ in }.store(in: &subsciptions)
        let result = try awaitSingle(output.error, actionHandler: {
            load.send()
        })
        XCTAssertTrue(result is Network.Errors, "Unexpected error type: \(type(of: result))")
        XCTAssertEqual(result as? Network.Errors, .unauthorized)
    }
    
    func testUserListModelSuccessResponse() throws {
        let load = PassthroughSubject<Void, Never>()
        let output = sut.transform(input: .init(load: load.eraseToAnyPublisher()))
        let expectation = self.expectation(description: "Awaiting publisher")
        var result: UserList.Model?
        output.userList
            .sink(receiveValue: {
                result = $0
                expectation.fulfill()
            })
            .store(in: &subsciptions)
        waitForExpectations(timeout: 10)
        XCTAssertEqual(result, UserList.Model.mockedUserList[0])
    }
    
    func testActivityIndicator() throws {
        userDetailService.userDetails = UserDetails.Model.mockedUserDetails
        let load = PassthroughSubject<Void, Never>()
        let output = sut.transform(input: .init(load: load.eraseToAnyPublisher()))
        output.userDetails.sink { _ in }.store(in: &subsciptions)

        let activityIndicatorPublisher = output.activityIndicator
            .collect(2)
            .first()
            .eraseToAnyPublisher()
        
        let result = try awaitSingle(activityIndicatorPublisher, actionHandler: {
            load.send()
        })
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result, [true, false])
    }
}
