//
//  UserDetails+Model.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

extension UserDetails {
    struct Model: Codable, Hashable {
        let login: String
        let id: Int64
        let nodeId: String
        let avatarUrl: String?
        let url: String?
        let organizationsUrl: String?
        let reposUrl: String?
        let type: String
        let siteAdmin: Bool
    }
}
