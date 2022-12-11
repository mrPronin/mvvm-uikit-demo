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
        func userListWith(paginationRequest: Pagination.Sink<UserList.Model>.Request) -> AnyPublisher<Pagination.Sink<UserList.Model>.Response, Error>
        {
            if let error = error {
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
            if let userListArray = userListArray {
                let response = Pagination.Sink<UserList.Model>.Response(
                    data: userListArray,
                    since: paginationRequest.since,
                    nextSince: paginationRequest.since + Pagination.perPage
                )
                return Just(response)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            return Empty().eraseToAnyPublisher()
        }
        
        var error: Error?
        var userListArray: [UserList.Model]?
        var userList: AnyPublisher<[UserList.Model], Error> {
            if let error = error {
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
            if let userListArray = userListArray {
                return Just<[UserList.Model]>(userListArray)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            return Empty().eraseToAnyPublisher()
        }
    }
}
