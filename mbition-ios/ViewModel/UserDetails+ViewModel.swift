//
//  UserDetails+ViewModel.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation
import Combine

// Define view model protocol
protocol UserDetailsViewModel {
    func transform(input: UserDetails.ViewModel.Input) -> UserDetails.ViewModel.Output
}

// Extend namespace
extension UserDetails { enum ViewModel {} }

// Define input / output
extension UserDetails.ViewModel {
    struct Input {
        let load: AnyPublisher<Void, Never>
    }
    struct Output {
        let userDetails: AnyPublisher<UserDetails.Model, Never>
        let error: AnyPublisher<Error, Never>
        let activityIndicator: AnyPublisher<Bool, Never>
        let loadingBanner: AnyPublisher<Bool, Never>
    }
}

// Implement view model
extension UserDetails.ViewModel {
    struct Implementation: UserDetailsViewModel {
        func transform(input: UserDetails.ViewModel.Input) -> UserDetails.ViewModel.Output {
            return UserDetails.ViewModel.Output(
                userDetails: Empty().eraseToAnyPublisher(),
                error: Empty().eraseToAnyPublisher(),
                activityIndicator: Empty().eraseToAnyPublisher(),
                loadingBanner: Empty().eraseToAnyPublisher()
            )
        }
        
        // MARK: - Init
        init(userDetailsService: UserDetailsService, userListModel: UserList.Model) {
            self.userDetailsService = userDetailsService
            self.userListModel = userListModel
        }
        
        // MARK: - Logic
        // MARK: - Dependency
        private let userDetailsService: UserDetailsService
        private let userListModel: UserList.Model
        
        // MARK: - Private
        private let errorSubject = PassthroughSubject<Error, Never>()
        private let activityIndicatorSubject = PassthroughSubject<Bool, Never>()
    }
}


