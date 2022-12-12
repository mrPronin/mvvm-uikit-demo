//
//  UserList.Model+mockedUserList.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 12.12.22.
//

import Foundation
@testable import mbition_ios

extension UserList.Model {
    static var mockedUserList: [UserList.Model] {
        let testBundle = Bundle(for: PaginationTests.self)
        let path = testBundle.path(forResource: "user-list", ofType: "json")!
        let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        var userList: [UserList.Model] = []
        do {
            userList = try JSONDecoder().decode([UserList.Model].self, from: data!)
        } catch {
            LOG(error)
        }
        return userList
    }
}
