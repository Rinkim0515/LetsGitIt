//
//  MockData.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import Foundation

class MockData {

    static let issueItem = [
        IssueItem(
            id: "1",
            title: "앱 크래시 이슈 수정",
            number: 42,
            author: "developer1"

        ),
        IssueItem(
            id: "2",
            title: "UI 개선 작업",
            number: 41,
            author: "designer1"
        ),
        IssueItem(
            id: "3",
            title: "API 연동 완료",
            number: 40,
            author: "backend-dev"
        )
    ]
    static let milestoneItem = [
        MilestoneItem(
            id: "1",
            title: "마일스톤 제목",
            description: "마일스톤 내용마일스톤 내용마일스톤 내용마일스톤 내용마일스톤 내용",
            tag: "Mobile App",
            tagColor: .systemPink,
            dday: "D+3",
            ddayType: .overdue,
            progress: 0.7
        ),
        MilestoneItem(
            id: "2",
            title: "마일스톤 제목",
            description: "마일스톤 내용마일스톤 내용마일스톤 내용마일스톤 내용마일스톤 내용",
            tag: "PC Web",
            tagColor: .systemBlue,
            dday: "D-3",
            ddayType: .upcoming,
            progress: 0.4
        ),
        MilestoneItem(
            id: "3",
            title: "추가 마일스톤",
            description: "세 번째 마일스톤 설명입니다",
            tag: "Backend",
            tagColor: .systemGreen,
            dday: "D-7",
            ddayType: .upcoming,
            progress: 0.2
        )
    ]
    static let commentItem: [CommentItem] = [
        // 1. 텍스트만
        CommentItem(
            id: "1",
            author: "boris7422",
            avatarURL: nil,
            createdAt: Date(),
            originalContent: """
            **버그 발생!** 앱이 _정말_ 이상하게 동작합니다.
            
            재현 방법:
            1. 로그인
            2. **설정** 페이지 이동
            3. `다크모드` 버튼 클릭
            
            급하게 수정 부탁드립니다! 🙏
            """
        ),
        
        // 2. 이미지만
        CommentItem(
            id: "2",
            author: "abcd1234",
            avatarURL: nil,
            createdAt: Date(),
            originalContent: "![스크린샷](https://user-images.githubusercontent.com/12345/screenshot.png)"
        ),
        
        // 3. 텍스트 + 이미지 (혼합)
        CommentItem(
            id: "3",
            author: "developer123",
            avatarURL: nil,
            createdAt: Date(),
            originalContent: """
            ### 문제 재현 완료 ✅
            
            다음과 같은 **에러**가 발생합니다:
            
            ![에러 스크린샷](https://user-images.githubusercontent.com/67890/error.png)
            
            **임시 해결책**: `localStorage.clear()` 호출하면 해결됩니다.
            """
        ),
        
        // 4. 다중 이미지
        CommentItem(
            id: "4",
            author: "tester456",
            avatarURL: nil,
            createdAt: Date(),
            originalContent: """
            테스트 결과입니다:
            
            ![테스트1](https://example.com/test1.png)
            ![테스트2](https://example.com/test2.png)
            ![테스트3](https://example.com/test3.png)
            
            모든 테스트 **통과**했습니다! 🎉
            """
        ),
        
        // 5. 빈 텍스트 + 이미지
        CommentItem(
            id: "5",
            author: "reviewer789",
            avatarURL: nil,
            createdAt: Date(),
            originalContent: "![결과](https://example.com/result.png)"
        )
    ]
    static let milestoneData: [MilestoneData] = [
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

//MARK: - DashBoardVC
extension MockData {
    // 그래프에 들어갈 데이터
    static let graph: [CGFloat] = [0.3, 0.7, 0.2, 0.9, 0.5, 0.8, 0.4]
    // DashboardVC안에 요일하단 일자에 들어갈 데이터
    static let DayInMonth = [30, 1, 2, 3, 4, 5, 6] // 일~토 날짜들
    // 일별로 코어타임에 달성했는지 여부파악을 위한 데이터
    static let weeklyData = WeeklyData(
        weekRange: "2025.06.01 ~ 2025.06.08",
        currentDate: Date(),
        dailyStatuses: [
            .past(isClosed: true),      // Sun: ✓
            .past(isClosed: true),      // Mon: ✓
            .past(isClosed: true),      // Tue: ✓
            .past(isClosed: true),      // Wed: ✓
            .past(isClosed: false),     // Thu: ✗
            .today,                     // Fri: 오늘
            .future(milestoneCount: 3)  // Sat: +3
        ],
        summary: "8/12 완료",
        currentStreak: 1,
        weeklyTotalHours: "03d 08h 15m",
        coreTimeSettings: "10:00 ~ 18:59"
    )
    // 사용자의 능력치 데이터
    static let recordStatsData = RecordStatsData(
        records: [
            "달성: 91/180",
            "마일스톤 누적 상위: 186 (Rank 60)",
            "최대 연속: 12 (Rank 46)",
            "누적 배지: 12 (Rank 32)",
            "총 코어 타임: ???"
        ]
    )
}

