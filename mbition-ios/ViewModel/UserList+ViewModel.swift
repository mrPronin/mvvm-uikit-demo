//
//  UserList+ViewModel.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation
import Combine

// Define view model protocol
protocol UserListViewModel {
    func transform(input: UserList.ViewModel.Input) -> UserList.ViewModel.Output
}

// Extend namespace
extension UserList { enum ViewModel {} }

// Define input / output
extension UserList.ViewModel {
    struct Input {
        let load: AnyPublisher<Void, Never>
    }
    struct Output {
        let userList: AnyPublisher<[UserList.Model], Never>
        let error: AnyPublisher<Error, Never>
        let activityIndicator: AnyPublisher<Bool, Never>
        let loadingBanner: AnyPublisher<Bool, Never>
    }
}

// Implementation
extension UserList.ViewModel {
    struct Implementation: UserListViewModel {
        func transform(input: UserList.ViewModel.Input) -> UserList.ViewModel.Output {
            return UserList.ViewModel.Output(
                userList: Empty().eraseToAnyPublisher(),
                error: Empty().eraseToAnyPublisher(),
                activityIndicator: Empty().eraseToAnyPublisher(),
                loadingBanner: Empty().eraseToAnyPublisher()
            )
        }
        
        // MARK: - Init
        // MARK: - Logic
        // MARK: - Dependency
        // MARK: - Private
    }
}
