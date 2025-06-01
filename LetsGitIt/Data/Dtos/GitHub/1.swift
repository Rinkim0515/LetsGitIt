//
//  1.swift
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


struct GitHubUserResponse: Codable {
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



struct GitHubMilestoneResponse: Codable {
    let id: Int
    let number: Int
    let title: String
    let description: String?
    let state: String
    let openIssues: Int
    let closedIssues: Int
    let dueOn: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, number, title, description, state
        case openIssues = "open_issues"
        case closedIssues = "closed_issues"
        case dueOn = "due_on"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct GitHubLabelResponse: Codable {
    let id: Int
    let name: String
    let color: String
    let description: String?
}

struct GitHubIssueResponse: Codable {
    let id: Int
    let number: Int
    let title: String
    let body: String?
    let state: String
    let labels: [GitHubLabelResponse]
    let assignee: GitHubUserResponse?
    let milestone: GitHubMilestoneResponse?
    let user: GitHubUserResponse
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, number, title, body, state, labels, assignee, milestone, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
