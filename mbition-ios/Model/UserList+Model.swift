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
        let avatarUrl: URL?
        let url: URL?
        let organizationsUrl: URL?
        let reposUrl: URL?
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
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            login = try container.decode(String.self, forKey: .login)
            id = try container.decode(Int.self, forKey: .id)
            nodeId = try container.decode(String.self, forKey: .nodeId)
            avatarUrl = try container.decode(URL.self, forKey: .avatarUrl)
            url = try container.decode(URL.self, forKey: .url)
            organizationsUrl = try container.decode(URL.self, forKey: .organizationsUrl)
            reposUrl = try container.decode(URL.self, forKey: .reposUrl)
            type = try container.decode(String.self, forKey: .type)
            siteAdmin = try container.decode(Bool.self, forKey: .siteAdmin)
        }
    }
}
