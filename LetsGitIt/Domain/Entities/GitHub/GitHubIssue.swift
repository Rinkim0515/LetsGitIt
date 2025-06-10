//
//  GitHubIssue.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation
import UIKit

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

extension GitHubIssue {
    
    var numberText: String {
        return "#\(number)"
    }
    var authorText: String {
        return "by \(author.login)"
    }
    
    var isOpen: Bool {
        return state == .open
    }
    
    var statusText: String {
        switch state {
        case .open: return "Open"
        case .closed: return "Closed"
        }
    }
    
    var statusColor: UIColor {
        switch state {
        case .open: return .systemGreen
        case .closed: return .systemPurple
        }
    }
    
    var statusIcon: String {
        switch state {
        case .open: return "circle"
        case .closed: return "checkmark"
        }
    }
    
    var createdDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self.createdAt)
    }
    
    var updatedDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: updatedAt)
    }
    
    // MARK: - 마일스톤 관련
    var milestoneText: String {
        return milestone?.title ?? "마일스톤 없음"
    }
    
    var hasMilestone: Bool {
        return milestone != nil
    }
    
    // MARK: - 담당자 관련
    var assigneeText: String {
        return assignee?.login ?? "담당자없음"
    }
    
    var hasAssignee: Bool {
        return assignee != nil
    }
}
