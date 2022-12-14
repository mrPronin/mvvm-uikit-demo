//
//  UserList+ViewController+Tests.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 14.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

class UserListViewControllerTests: XCTestCase {
    var sut: UserList.ViewController!
    var viewModel: UserList.ViewModel.Mock!
    var router: UserList.RouterMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = UserList.ViewModel.Mock()
        sut = UserList.ViewController(viewModel: viewModel)
        router = UserList.RouterMock()
        sut.router = router
        UIView.performWithoutAnimation {
            let window = UIWindow()
            window.rootViewController = sut
            window.makeKeyAndVisible()
        }
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        viewModel = nil
        router = nil
        sut = nil
    }
    
    func testInstantiate() throws {
        XCTAssertNotNil(sut.view)
    }
    
    func testActivityIndicatorShown() {
        XCTAssertFalse(sut.view.subviews.map { $0 is ActivityIndicator }.contains(true))
        viewModel.activityIndicatorSubject.send(true)
        XCTAssertTrue(sut.view.subviews.map { $0 is ActivityIndicator }.contains(true))
    }
    
    func testActivityIndicatorHidden() {
        viewModel.activityIndicatorSubject.send(true)
        XCTAssertTrue(sut.view.subviews.map { $0 is ActivityIndicator }.contains(true))
        viewModel.activityIndicatorSubject.send(false)
        XCTAssertFalse(sut.view.subviews.map { $0 is ActivityIndicator }.contains(true))
    }
}
