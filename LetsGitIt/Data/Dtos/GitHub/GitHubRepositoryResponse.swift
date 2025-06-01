//
//  GitHubRepositoryResponse.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

struct GitHubRepositoryResponse: Codable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let language: String?
    let stargazersCount: Int
    let forksCount: Int
    let updatedAt: String
    let isPrivate: Bool
    let owner: GitHubUserResponse
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case updatedAt = "updated_at"
        case isPrivate = "private"
        case owner
    }
}
