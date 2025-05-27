//
//  NetworkModels.swift
//  LetsGitIt
//
//  Created by KimRin on 5/27/25.
//

// Network/NetworkModels.swift
import Foundation

// MARK: - User Models
struct GitHubUser: Codable {
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

// MARK: - Repository Models
struct GitHubRepository: Codable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let language: String?
    let stargazersCount: Int
    let forksCount: Int
    let updatedAt: String
    let isPrivate: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case updatedAt = "updated_at"
        case isPrivate = "private"
    }
}

// MARK: - Error Types
enum GitHubAPIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case invalidResponse
}
