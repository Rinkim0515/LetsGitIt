//
//  GitHubPullRequest.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

struct GitHubPullRequest {
    let id: Int
    let number: Int
    let title: String
    let body: String?
    let state: GitHubPullRequestState
    let author: GitHubUser
    let assignee: GitHubUser?
    let milestone: GitHubMilestone?
    let baseBranch: String
    let headBranch: String
    let createdAt: Date
    let updatedAt: Date
    let mergedAt: Date?
}

enum GitHubPullRequestState {
    case open
    case closed
    case merged
}
