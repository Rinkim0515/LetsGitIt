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
    let publicRepos: Int?      // ✅ Optional로 변경
    let followers: Int?        // ✅ Optional로 변경
    let following: Int?        // ✅ Optional로 변경
    
    enum CodingKeys: String, CodingKey {
        case id, login, name, bio
        case avatarUrl = "avatar_url"
        case publicRepos = "public_repos"
        case followers, following
    }
}








