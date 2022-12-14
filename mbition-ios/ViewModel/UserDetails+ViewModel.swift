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
        let userList: AnyPublisher<UserList.Model, Never>
        let userDetails: AnyPublisher<UserDetails.Model, Never>
        let error: AnyPublisher<Error, Never>
        let activityIndicator: AnyPublisher<Bool, Never>
    }
}

// Implement view model
extension UserDetails.ViewModel {
    struct Implementation: UserDetailsViewModel {
        func transform(input: UserDetails.ViewModel.Input) -> UserDetails.ViewModel.Output {
            
            return UserDetails.ViewModel.Output(
                userList: Just(userListModel).eraseToAnyPublisher(),
                userDetails: userDetails(input, userListModel: userListModel),
                error: errorSubject.eraseToAnyPublisher(),
                activityIndicator: activityIndicatorSubject.eraseToAnyPublisher()
            )
        }
        
        // MARK: - Init
        init(userDetailsService: UserDetailsService, userListModel: UserList.Model) {
            self.userDetailsService = userDetailsService
            self.userListModel = userListModel
        }
        
        // MARK: - Logic
        func userDetails(_ input: UserDetails.ViewModel.Input, userListModel: UserList.Model) -> AnyPublisher<UserDetails.Model, Never> {
            input.load
                .handleEvents(receiveOutput: { _ in
                    // show activity indicator and loading banner
                    self.activityIndicatorSubject.send(true)
                })
                .flatMap { _ in self.userDetailsService.fetchUserDetails(with: self.userListModel.login) }
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveOutput: { _ in
                    // hide activity indicator and loading banner
                    self.activityIndicatorSubject.send(false)
                })
                .catch { error -> AnyPublisher<UserDetails.Model, Never> in
                    DispatchQueue.main.async {
                        self.activityIndicatorSubject.send(false)
                        self.errorSubject.send(error)
                    }
                    return Empty().eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
        
        // MARK: - Dependency
        private let userDetailsService: UserDetailsService
        private let userListModel: UserList.Model
        
        // MARK: - Private
        private let errorSubject = PassthroughSubject<Error, Never>()
        private let activityIndicatorSubject = PassthroughSubject<Bool, Never>()
    }
}
