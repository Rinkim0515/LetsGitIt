//
//  MockData.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import Foundation

class MockData {
    
    // ✅ GitHubMilestone 사용 (MilestoneItem 대체)
    static let sampleMilestones: [GitHubMilestone] = [
        GitHubMilestone(
            id: 1,
            number: 1,
            title: "Sprint 1 개발",
            description: "로그인, 회원가입, 프로필 기능 개발을 포함한 첫 번째 스프린트입니다.",
            state: .open,
            openIssues: 3,
            closedIssues: 9,
            dueDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()),
            createdAt: Date(),
            updatedAt: Date()
        ),
        GitHubMilestone(
            id: 2,
            number: 2,
            title: "UI/UX 개선",
            description: "사용자 경험 향상을 위한 인터페이스 디자인 및 사용성 개선 작업입니다.",
            state: .open,
            openIssues: 7,
            closedIssues: 5,
            dueDate: Calendar.current.date(byAdding: .day, value: 14, to: Date()),
            createdAt: Date(),
            updatedAt: Date()
        ),
        GitHubMilestone(
            id: 3,
            number: 3,
            title: "Beta 테스트",
            description: "실제 사용자를 대상으로 한 베타 테스트 및 피드백 수집 단계입니다.",
            state: .open,
            openIssues: 1,
            closedIssues: 9,
            dueDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()),
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
    
    // ✅ GitHubIssue 사용 (기존 IssueItem 제거됨)
    static let sampleIssues: [GitHubIssue] = [
        GitHubIssue(
            id: 1,
            number: 42,
            title: "앱 크래시 이슈 수정",
            body: "앱이 특정 조건에서 크래시되는 문제를 수정해야 합니다.",
            state: .open,
            labels: [],
            assignee: nil,
            milestone: sampleMilestones[0],
            author: GitHubUser(id: 1, login: "developer1", name: "Developer One", avatarURL: "https://github.com/images/error/octocat_happy.gif", bio: nil, publicRepos: 10, followers: 100, following: 50),
            createdAt: Date(),
            updatedAt: Date()
        ),
        GitHubIssue(
            id: 2,
            number: 41,
            title: "UI 개선 작업",
            body: "사용자 인터페이스를 더 직관적으로 개선하는 작업입니다.",
            state: .open,
            labels: [],
            assignee: nil,
            milestone: sampleMilestones[1],
            author: GitHubUser(id: 2, login: "designer1", name: "Designer One", avatarURL: "https://github.com/images/error/octocat_happy.gif", bio: nil, publicRepos: 5, followers: 80, following: 30),
            createdAt: Date(),
            updatedAt: Date()
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
        )
    ]
    
    // ✅ 기존 MilestoneData에서 GitHubMilestone + GitHubIssue 조합으로 변경
    static let milestoneWithIssues: [(milestone: GitHubMilestone, issues: [GitHubIssue])] = [
        (milestone: sampleMilestones[0], issues: [sampleIssues[0]]),
        (milestone: sampleMilestones[1], issues: [sampleIssues[1]]),
        (milestone: sampleMilestones[2], issues: [])
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
