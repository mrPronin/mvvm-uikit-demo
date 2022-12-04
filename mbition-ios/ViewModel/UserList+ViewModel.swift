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
    }
}

// Implement view model
extension UserList.ViewModel {
    struct Implementation: UserListViewModel {
        func transform(input: UserList.ViewModel.Input) -> UserList.ViewModel.Output {
            return UserList.ViewModel.Output(
                userList: userList(input),
                error: errorSubject.eraseToAnyPublisher(),
                activityIndicator: activityIndicatorSubject.eraseToAnyPublisher()
            )
        }
        
        // MARK: - Init
        init(userListService: UserListService) {
            self.userListService = userListService
        }
        // MARK: - Logic
        func userList(_ input: UserList.ViewModel.Input) -> AnyPublisher<[UserList.Model], Never> {
            return input.load
                .handleEvents(receiveOutput: { _ in
                    // show activity indicator and loading banner
                    self.activityIndicatorSubject.send(true)
                })
                .flatMap { _ in self.userListService.userList}
                .receive(on: DispatchQueue.main)
                .delay(for: .seconds(5), scheduler: DispatchQueue.main)
                .handleEvents(receiveOutput: { list in
                    // hide activity indicator and loading banner
                    self.activityIndicatorSubject.send(false)

                })
                .catch { error -> AnyPublisher<[UserList.Model], Never> in
                    DispatchQueue.main.async {
                        self.activityIndicatorSubject.send(false)
                        self.errorSubject.send(error)
                    }
                    return Empty().eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
        
        // MARK: - Dependency
        private let userListService: UserListService
        
        // MARK: - Private
        private let errorSubject = PassthroughSubject<Error, Never>()
        private let activityIndicatorSubject = PassthroughSubject<Bool, Never>()
        private let loadingBannerSubject = PassthroughSubject<Bool, Never>()
    }
}
