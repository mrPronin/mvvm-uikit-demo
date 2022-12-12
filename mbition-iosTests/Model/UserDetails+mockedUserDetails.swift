//
//  UserDetails+mockedUserDetails.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 12.12.22.
//

import Foundation
@testable import mbition_ios

extension UserDetails.Model {
    static var mockedUserDetails: UserDetails.Model? {
        let testBundle = Bundle(for: UserDetails.ViewController.self)
        let path = testBundle.path(forResource: "user-details", ofType: "json")!
        let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        var userDetails: UserDetails.Model?
        do {
            userDetails = try JSONDecoder().decode(UserDetails.Model.self, from: data!)
        } catch {
            LOG(error)
        }
        return userDetails
    }
}
