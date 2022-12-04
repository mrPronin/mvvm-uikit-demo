//
//  UserList+Service+Mock.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation
import Combine

//@testable import mbition_ios

extension UserList.Service {
    class Mock: UserListService {
        var error: Error?
        var userListArray: [UserList.Model]?
        var userList: AnyPublisher<[UserList.Model], Error> {
            if let userListArray = userListArray {
                return Just<[UserList.Model]>(userListArray)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            return Empty().eraseToAnyPublisher()
        }
    }
}
