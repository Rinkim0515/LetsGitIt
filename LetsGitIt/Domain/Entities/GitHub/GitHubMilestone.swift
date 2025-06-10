//
//  GitHubMilestone.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation
import UIKit

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

extension GitHubMilestone {
    
    
    var ddayText: String {
        guard let dueDate = dueDate else { return "기한없음" }
        
        let calendar = Calendar.current
        let now = Date()
        let days = calendar.dateComponents([.day], from: now, to: dueDate).day ?? 0
        
        if days > 0 {
            return "D-\(days)"
        } else if days < 0 {
            return "D+\(abs(days))"
        } else {
            return "D-Day"
        }
    }
    
    var ddayType: DDayType {
        guard let dueDate = dueDate else { return .upcoming }
        return Date() > dueDate ? .overdue : .upcoming
    }
    
    // MARK: - UI 표시용 텍스트
    var displayDescription: String {
        return description ?? "설명 없음"
    }
    
    var tagText: String {
        return "Milestone"
    }
    
    var tagColor: UIColor {
        switch state {
        case .open: return .systemBlue
        case .closed: return .systemGray
        }
    }
    
    // MARK: - 진행률 관련
    var progressText: String {
        let percentage = Int(progress * 100)
        return "\(percentage)%"
    }
    
    var issuesSummaryText: String {
        return "\(openIssues) open / \(closedIssues) closed"
    }
    
    // MARK: - 상태 확인
    var isOverdue: Bool {
        guard let dueDate = dueDate else { return false }
        return Date() > dueDate && state == .open
    }
}
