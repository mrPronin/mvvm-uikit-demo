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
        
        // MARK: - Init
        // MARK: - Private
    }
}
