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
        let loadNextPage: AnyPublisher<Void, Never>
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
        typealias PaginationSink = Pagination.Sink<UserList.Model>
        func transform(input: UserList.ViewModel.Input) -> UserList.ViewModel.Output {
            let uiSource = Pagination.UISource(
                reload: input.load,
                loadNextPage: input.loadNextPage
            )
            let sink = PaginationSink(ui: uiSource, loadData: userListService.userListWith(paginationRequest:))
            
            return UserList.ViewModel.Output(
                userList: sink.elements,
                error: sink.error,
                activityIndicator: sink.activityIndicator
            )
        }
        
        // MARK: - Init
        init(userListService: UserListService) {
            self.userListService = userListService
        }
        // MARK: - Logic
        
        // MARK: - Dependency
        private let userListService: UserListService
        
        // MARK: - Private
        private let errorSubject = PassthroughSubject<Error, Never>()
        private let activityIndicatorSubject = PassthroughSubject<Bool, Never>()
    }
}
