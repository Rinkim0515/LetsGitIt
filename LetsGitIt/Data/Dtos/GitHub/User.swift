//
//  1.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

struct GitHubUserDTO: Codable {
    let id: Int
    let login: String
    let name: String?
    let avatarUrl: String
    let bio: String?
    let publicRepos: Int
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case id, login, name, bio, followers, following
        case avatarUrl = "avatar_url"
        case publicRepos = "public_repos"
    }
}








