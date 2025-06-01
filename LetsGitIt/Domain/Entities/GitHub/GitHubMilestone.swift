//
//  GitHubMilestone.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

struct GitHubMilestone {
    let id: Int
    let number: Int
    let title: String
    let description: String?
    let state: GitHubMilestoneState
    let openIssues: Int
    let closedIssues: Int
    let dueDate: Date?
    let createdAt: Date
    let updatedAt: Date
    
    var progress: Double {
        let total = openIssues + closedIssues
        return total > 0 ? Double(closedIssues) / Double(total) : 0.0
    }
}

enum GitHubMilestoneState {
    case open
    case closed
}

