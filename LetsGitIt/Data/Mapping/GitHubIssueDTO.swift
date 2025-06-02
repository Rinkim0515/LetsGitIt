//
//  GitHubIssueResponse.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

extension GitHubIssueDTO {
    func toDomain() -> GitHubIssue {
        return GitHubIssue(
            id: id,
            number: number,
            title: title,
            body: body,
            state: state.lowercased() == "open" ? .open : .closed,  // String → Enum 변환
            labels: labels.map { $0.toDomain() },  // 배열 변환
            assignee: assignee?.toDomain(),
            milestone: milestone?.toDomain(),
            author: user.toDomain(),
            createdAt: ISO8601DateFormatter().date(from: createdAt) ?? Date(),
            updatedAt: ISO8601DateFormatter().date(from: updatedAt) ?? Date()
        )
    }
}
