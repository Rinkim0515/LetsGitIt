//
//  1.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

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
