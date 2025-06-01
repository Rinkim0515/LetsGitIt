//
//  GitHubIssueResponse.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

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
