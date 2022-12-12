//
//  UserList+Service.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation
import Combine

// Define service protocol
protocol UserListService {
    var userList: AnyPublisher<[UserList.Model], Error> { get }
    func userListWith(paginationRequest: Pagination.Sink<UserList.Model>.Request) -> AnyPublisher<Pagination.Sink<UserList.Model>.Response, Error>
}

// Extend namespace
extension UserList { enum Service {} }

// Implement service
extension UserList.Service {
    struct Implementation: UserListService {
        // MARK: - Public
        var userList: AnyPublisher<[UserList.Model], Error> {
            return URLSession.shared.publisher(for: .userList)
                .eraseToAnyPublisher()
        }
        func userListWith(paginationRequest: Pagination.Sink<UserList.Model>.Request) -> AnyPublisher<Pagination.Sink<UserList.Model>.Response, Error> {
            return URLSession.shared.publisherWithPagination(for: .userListWith(paginationRequest: paginationRequest))
                .subscribe(on: DispatchQueue.global(qos: .default))
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}
