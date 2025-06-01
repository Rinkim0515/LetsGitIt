//
//  User.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

struct GitHubUser {
    let id: Int
    let login: String
    let name: String?
    let avatarURL: String
    let bio: String?
    let publicRepos: Int
    let followers: Int
    let following: Int
}
