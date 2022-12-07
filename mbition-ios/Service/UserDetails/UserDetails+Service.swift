//
//  UserDetails+Service.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 07.12.22.
//

import Foundation
import Combine

// Define service protocol
protocol UserDetailsService {
    func fetchUserDetails(with userLoginId: String) -> AnyPublisher<UserDetails.Model, Error>
}

// Extend namespace
extension UserDetails { enum Service {} }

// Implement service
extension UserDetails.Service {
    struct Implementation: UserDetailsService {
        // MARK: - Public
        func fetchUserDetails(with userLoginId: String) -> AnyPublisher<UserDetails.Model, Error> {
            return Empty().eraseToAnyPublisher()
        }
    }
}
