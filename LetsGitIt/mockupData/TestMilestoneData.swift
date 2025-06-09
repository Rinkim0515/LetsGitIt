//
//  TestMileStone.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import Foundation

extension MilestoneData {
    static let mockData: [MilestoneData] = [
        MilestoneData(
            id: "1",
            name: "Sprint 1",
            issues: [
                IssueItem(id: "1", title: "로그인 기능 구현", number: 45, author: "developer1"),
                IssueItem(id: "2", title: "UI 개선 작업", number: 44, author: "designer1"),
                IssueItem(id: "3", title: "API 연동 완료", number: 43, author: "backend-dev"),
                IssueItem(id: "4", title: "테스트 코드 작성", number: 42, author: "tester1"),
                IssueItem(id: "5", title: "버그 수정", number: 41, author: "developer2")
            ]
        ),
        
        MilestoneData(
            id: "2",
            name: "Sprint 2",
            issues: [
                IssueItem(id: "6", title: "프로필 페이지 구현", number: 40, author: "frontend-dev"),
                IssueItem(id: "7", title: "알림 기능 추가", number: 39, author: "developer3"),
                IssueItem(id: "8", title: "성능 최적화", number: 38, author: "performance-team")
            ]
        ),
        
        MilestoneData(
            id: "3",
            name: "Bug Fix Release",
            issues: [
                IssueItem(id: "9", title: "크래시 이슈 해결", number: 37, author: "qa-team"),
                IssueItem(id: "10", title: "메모리 누수 수정", number: 36, author: "developer4")
            ]
        ),
        
        MilestoneData(
            id: "4",
            name: "v2.0 Major Update",
            issues: [
                IssueItem(id: "11", title: "새로운 디자인 시스템", number: 35, author: "design-team"),
                IssueItem(id: "12", title: "다크모드 지원", number: 34, author: "ui-developer"),
                IssueItem(id: "13", title: "다국어 지원", number: 33, author: "localization-team"),
                IssueItem(id: "14", title: "접근성 개선", number: 32, author: "accessibility-team")
            ]
        ),
        
        MilestoneData(
            id: "5",
            name: "Empty Milestone",
            issues: [] // 빈 마일스톤 (테스트용)
        )
    ]
}
