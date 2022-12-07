//
//  UserDetails+Service-Mock.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 07.12.22.
//

import Foundation
import Combine

extension UserDetails.Service {
    class Mock: UserDetailsService {
        var error: Error?
        var userDetails: UserDetails.Model?
        
        func fetchUserDetails(with userLoginId: String) -> AnyPublisher<UserDetails.Model, Error> {
            if let userDetails = userDetails {
                return Just<UserDetails.Model>(userDetails)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            return Empty().eraseToAnyPublisher()
        }
    }
}
