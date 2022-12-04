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
        let id: Int
        let nodeId: String
        let avatarUrl: String?
        let url: String?
        let organizationsUrl: String?
        let reposUrl: String?
        let type: String
        let siteAdmin: Bool
        
        let name: String?
        let company: String?
        let blog: String?
        let location: String?
        let email: String?
        let hireable: String?
        let bio: String?
        let twitterUsername: String?
        let publicRepos: Int
        let publicGists: Int
        let followers: Int
        let following: Int
        let createdAt: String
        let updatedAt: String
    }
}
