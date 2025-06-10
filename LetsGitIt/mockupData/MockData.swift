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
    static let milestoneItem1 = [
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
    static let milestoneData1: [MilestoneData] = [
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
    static let milestonesItem2: [MilestoneItem] =  [
        MilestoneItem(
            id: "1",
            title: "Sprint 1 개발",
            description: "로그인, 회원가입, 프로필 기능 개발을 포함한 첫 번째 스프린트입니다.",
            tag: "Development",
            tagColor: .systemBlue,
            dday: "D-7",
            ddayType: .upcoming,
            progress: 0.75
        ),
        MilestoneItem(
            id: "2",
            title: "UI/UX 개선",
            description: "사용자 경험 향상을 위한 인터페이스 디자인 및 사용성 개선 작업입니다.",
            tag: "Design",
            tagColor: .systemPink,
            dday: "D-14",
            ddayType: .upcoming,
            progress: 0.45
        ),
        MilestoneItem(
            id: "3",
            title: "Beta 테스트",
            description: "실제 사용자를 대상으로 한 베타 테스트 및 피드백 수집 단계입니다.",
            tag: "Testing",
            tagColor: .systemOrange,
            dday: "D+3",
            ddayType: .overdue,
            progress: 0.90
        ),
        MilestoneItem(
            id: "4",
            title: "출시 준비",
            description: "앱 스토어 등록, 마케팅 자료 준비, 최종 배포 준비 작업입니다.",
            tag: "Release",
            tagColor: .systemGreen,
            dday: "D-21",
            ddayType: .upcoming,
            progress: 0.20
        ),
        MilestoneItem(
            id: "5",
            title: "성능 최적화",
            description: "앱 성능 개선 및 메모리 사용량 최적화 작업을 진행합니다.",
            tag: "Performance",
            tagColor: .systemPurple,
            dday: "D-30",
            ddayType: .upcoming,
            progress: 0.10
        )
    ]
    //issueDetailViewController에서 issue내용
    static let issueContent = CommentData(
        author: "Mock123",
        createdAt: Date(), // Mock 데이터
        content: "**버그 발생!** 앱이 _정말_ 이상하게 동작합니다.\n\n재현 방법:\n1. 로그인\n2. **설정** 페이지 이동\n3. `다크모드` 버튼 클릭\n\n급하게 수정 부탁드립니다! 🙏"
    )
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
    static let mileStoneDetail: MilestoneDetail = {
        let milestoneTitle: String = "Test Milestone"
        let issueCount: Int = 8
        let closedRatio: Double = 0.6
        let closedCount = Int(Double(issueCount) * closedRatio)
        let openCount = issueCount - closedCount
        
        let mockMilestone = GitHubMilestone(
            id: 1,
            number: 1,
            title: milestoneTitle,
            description: "테스트용 마일스톤입니다. 실제 API 연동 전까지 사용됩니다.",
            state: .open,
            openIssues: openCount,
            closedIssues: closedCount,
            dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // Mock GitHubIssues
        var mockIssues: [GitHubIssue] = []
        
        for i in 1...issueCount {
            let isOpen = i <= openCount
            let mockUser = GitHubUser(
                id: i,
                login: "developer\(i)",
                name: "Developer \(i)",
                avatarURL: "https://github.com/images/error/octocat_happy.gif",
                bio: nil,
                publicRepos: 10,
                followers: 100,
                following: 50
            )
            
            let mockIssue = GitHubIssue(
                id: i,
                number: 50 - i,
                title: "이슈 제목 \(i)",
                body: "이슈 내용입니다. 테스트용 데이터입니다.",
                state: isOpen ? .open : .closed,
                labels: [],
                assignee: i % 3 == 0 ? mockUser : nil,
                milestone: mockMilestone,
                author: mockUser,
                createdAt: Date(),
                updatedAt: Date()
            )
            
            mockIssues.append(mockIssue)
        }
        
        return MilestoneDetail(
            milestone: mockMilestone,
            issues: mockIssues
        )
    }()
    
    
    
    
    
    
}
