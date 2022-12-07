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
        let avatarUrl: URL?
        let url: URL?
        
        private enum CodingKeys: String, CodingKey {
            case login
            case avatarUrl = "avatar_url"
            case url
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            login = try container.decode(String.self, forKey: .login)
            avatarUrl = try container.decode(URL.self, forKey: .avatarUrl)
            url = try container.decode(URL.self, forKey: .url)
        }
    }
}
