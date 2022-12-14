//
//  UserDetails+ViewModel+Mock.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 14.12.22.
//

import XCTest
import Combine
@testable import mbition_ios

extension UserDetails.ViewModel {
    class Mock: UserDetailsViewModel {
        let errorSubject = PassthroughSubject<Error, Never>()
        let activityIndicatorSubject = PassthroughSubject<Bool, Never>()
        func transform(input: UserDetails.ViewModel.Input) -> UserDetails.ViewModel.Output {
            UserDetails.ViewModel.Output(
                userList: Empty().eraseToAnyPublisher(),
                userDetails: Empty().eraseToAnyPublisher(),
                error: errorSubject.eraseToAnyPublisher(),
                activityIndicator: activityIndicatorSubject.eraseToAnyPublisher()
            )
        }
    }
}
