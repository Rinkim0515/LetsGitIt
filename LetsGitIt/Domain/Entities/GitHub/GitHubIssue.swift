//
//  GitHubIssue.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

struct GitHubIssue {
    let id: Int
    let number: Int
    let title: String
    let body: String?
    let state: GitHubIssueState
    let labels: [GitHubLabel]
    let assignee: GitHubUser?
    let milestone: GitHubMilestone?
    let author: GitHubUser
    let createdAt: Date
    let updatedAt: Date
}

enum GitHubIssueState {
    case open
    case closed
}
