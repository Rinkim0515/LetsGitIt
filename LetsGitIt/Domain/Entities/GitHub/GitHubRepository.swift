//
//  GitHubRepository.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

struct GitHubRepository {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let language: String?
    let starCount: Int
    let forkCount: Int
    let isPrivate: Bool
    let owner: GitHubUser
    let updatedAt: Date
}
