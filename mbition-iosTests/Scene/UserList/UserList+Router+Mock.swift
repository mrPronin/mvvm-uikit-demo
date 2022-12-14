//
//  UserList+Router+Mock.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 14.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

extension UserList {
    class RouterMock: UserListRouter {
        func navigateToUser(with userListItem: UserList.Model) {}
    }
}
