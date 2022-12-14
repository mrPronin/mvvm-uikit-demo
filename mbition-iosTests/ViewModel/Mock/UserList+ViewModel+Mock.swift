//
//  UserList+ViewModel+Mock.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 14.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

extension UserList.ViewModel {
    class Mock: UserListViewModel {
        let errorSubject = PassthroughSubject<Error, Never>()
        let activityIndicatorSubject = PassthroughSubject<Bool, Never>()
        func transform(input: UserList.ViewModel.Input) -> UserList.ViewModel.Output {
            UserList.ViewModel.Output(
                userList: Empty().eraseToAnyPublisher(),
                error: errorSubject.eraseToAnyPublisher(),
                activityIndicator: activityIndicatorSubject.eraseToAnyPublisher()
            )
        }
    }
}
