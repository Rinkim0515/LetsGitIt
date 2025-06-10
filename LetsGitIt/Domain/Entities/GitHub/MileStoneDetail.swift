//
//  MilestoneDetail.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import Foundation

// MARK: - MilestoneDetail Domain Model
struct MilestoneDetail {
    let milestone: GitHubMilestone
    let issues: [GitHubIssue]
    
    // MARK: - Computed Properties
    var totalIssues: Int {
        return issues.count
    }
    
    var openIssues: [GitHubIssue] {
        return issues.filter { $0.state == .open }
    }
    
    var closedIssues: [GitHubIssue] {
        return issues.filter { $0.state == .closed }
    }
    
    var openIssuesCount: Int {
        return openIssues.count
    }
    
    var closedIssuesCount: Int {
        return closedIssues.count
    }
    
    var progressPercentage: Double {
        guard totalIssues > 0 else { return 0.0 }
        return Double(closedIssuesCount) / Double(totalIssues)
    }
    
    // MARK: - Helper Methods
    /// 특정 상태의 이슈들만 필터링
    func issues(with state: GitHubIssueState) -> [GitHubIssue] {
        return issues.filter { $0.state == state }
    }
    
    /// 특정 라벨을 가진 이슈들만 필터링
    func issues(with labelName: String) -> [GitHubIssue] {
        return issues.filter { issue in
            issue.labels.contains { $0.name.lowercased() == labelName.lowercased() }
        }
    }
    
    /// 특정 담당자의 이슈들만 필터링
    func issues(assignedTo login: String) -> [GitHubIssue] {
        return issues.filter { issue in
            issue.assignee?.login.lowercased() == login.lowercased()
        }
    }
}

// MARK: - MilestoneDetail Extensions
extension MilestoneDetail {
    /// 진행률을 퍼센트 문자열로 반환 (예: "75%")
    var progressText: String {
        let percentage = Int(progressPercentage * 100)
        return "\(percentage)%"
    }
    
    /// 이슈 개수 요약 텍스트 (예: "3 open / 5 closed")
    var issuesSummaryText: String {
        return "\(openIssuesCount) open / \(closedIssuesCount) closed"
    }
    
    /// Due Date를 포맷된 문자열로 반환
    var dueDateText: String? {
        guard let dueDate = milestone.dueDate else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return "Due by \(formatter.string(from: dueDate))"
    }
    
    /// 마일스톤 상태가 Open인지 확인
    var isOpen: Bool {
        return milestone.state == .open
    }
    
    /// 마일스톤이 기한 초과인지 확인
    var isOverdue: Bool {
        guard let dueDate = milestone.dueDate else { return false }
        return Date() > dueDate && isOpen
    }
    
    /// D-day 계산 (예: "D-7", "D+3")
    var ddayText: String? {
        guard let dueDate = milestone.dueDate else { return nil }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let targetDate = calendar.startOfDay(for: dueDate)
        
        let components = calendar.dateComponents([.day], from: today, to: targetDate)
        guard let dayDifference = components.day else { return nil }
        
        if dayDifference > 0 {
            return "D-\(dayDifference)"
        } else if dayDifference < 0 {
            return "D+\(abs(dayDifference))"
        } else {
            return "D-Day"
        }
    }
}


