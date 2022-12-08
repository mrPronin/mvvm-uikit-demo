//
//  UserDetails+Model.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

extension UserDetails {
    struct Model: Codable, Hashable {
        let name: String?
        let company: String?
        let location: String?
        let twitterUsername: String?
        let publicRepos: Int
        let publicGists: Int
        let followers: Int
        let following: Int
        let createdAt: String
        let updatedAt: String
        
        private enum CodingKeys: String, CodingKey {
            case name
            case company
            case location
            case twitterUsername = "twitter_username"
            case publicRepos = "public_repos"
            case publicGists = "public_gists"
            case followers
            case following
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}
