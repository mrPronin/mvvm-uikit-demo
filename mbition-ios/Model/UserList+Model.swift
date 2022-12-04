//
//  UserList+Model.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

extension UserList {
    struct Model: Codable, Hashable {
        let login: String
        let id: Int
        let nodeId: String
        let avatarUrl: String?
        let url: String?
        let organizationsUrl: String?
        let reposUrl: String?
        let type: String
        let siteAdmin: Bool
        private enum CodingKeys: String, CodingKey {
            case login
            case id
            case nodeId = "node_id"
            case avatarUrl = "avatar_url"
            case url
            case organizationsUrl = "organizations_url"
            case reposUrl = "repos_url"
            case type
            case siteAdmin = "site_admin"
        }
    }
}
