//
//  GitHubMilestoneResponse.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

extension GitHubMilestoneDTO {
    func toDomain() -> GitHubMilestone {
        let dueDate: Date?
        if let dueOn = dueOn {
            dueDate = ISO8601DateFormatter().date(from: dueOn)
        } else {
            dueDate = nil
        }
        
        return GitHubMilestone(
            id: id,
            number: number,
            title: title,
            description: description,
            state: state.lowercased() == "open" ? .open : .closed,
            openIssues: openIssues,
            closedIssues: closedIssues,
            dueDate: dueDate,
            createdAt: ISO8601DateFormatter().date(from: createdAt) ?? Date(),
            updatedAt: ISO8601DateFormatter().date(from: updatedAt) ?? Date()
        )
    }
}
