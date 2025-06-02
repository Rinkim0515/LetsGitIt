//
//  GitHubIssueDTO.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

struct GitHubIssueDTO: Codable {
    let id: Int
    let number: Int
    let title: String
    let body: String?
    let state: String
    let labels: [GitHubLabelDTO]
    let assignee: GitHubUserDTO?
    let milestone: GitHubMilestoneDTO?
    let user: GitHubUserDTO
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, number, title, body, state, labels, assignee, milestone, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
