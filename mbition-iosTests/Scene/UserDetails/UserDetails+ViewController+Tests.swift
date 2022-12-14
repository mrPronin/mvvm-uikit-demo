//
//  UserDetails+ViewController+Tests.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 14.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

class UserDetailsViewControllerTests: XCTestCase {
    var sut: UserDetails.ViewController!
    var viewModel: UserDetails.ViewModel.Mock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = UserDetails.ViewModel.Mock()
        sut = UserDetails.ViewController(viewModel: viewModel)
        UIView.performWithoutAnimation {
            let window = UIWindow()
            window.rootViewController = sut
            window.makeKeyAndVisible()
        }
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        viewModel = nil
        sut = nil
    }
    
    func testInstantiate() throws {
        XCTAssertNotNil(sut.view)
    }
    
    func testActivityIndicatorShown() {
        XCTAssertFalse(sut.detailsSectionView.subviews.map { $0 is ActivityIndicator }.contains(true))
        viewModel.activityIndicatorSubject.send(true)
        XCTAssertTrue(sut.detailsSectionView.subviews.map { $0 is ActivityIndicator }.contains(true))
    }
    
    func testActivityIndicatorHidden() {
        viewModel.activityIndicatorSubject.send(true)
        XCTAssertTrue(sut.detailsSectionView.subviews.map { $0 is ActivityIndicator }.contains(true))
        viewModel.activityIndicatorSubject.send(false)
        XCTAssertFalse(sut.detailsSectionView.subviews.map { $0 is ActivityIndicator }.contains(true))
    }
}
