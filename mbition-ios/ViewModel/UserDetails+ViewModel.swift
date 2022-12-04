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
        let userList: AnyPublisher<[UserDetails.Model], Never>
        let error: AnyPublisher<Error, Never>
        let activityIndicator: AnyPublisher<Bool, Never>
        let loadingBanner: AnyPublisher<Bool, Never>
    }
}

// Implementation
extension UserDetails.ViewModel {
    struct Implementation: UserDetailsViewModel {
        func transform(input: UserDetails.ViewModel.Input) -> UserDetails.ViewModel.Output {
            return UserDetails.ViewModel.Output(
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


