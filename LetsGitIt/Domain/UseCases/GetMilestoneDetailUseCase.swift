//
//  GetMilestoneDetailUseCase.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import Foundation


final class GetMilestoneDetailUseCase {
    private let milestoneRepository: GitHubMilestoneRepositoryProtocol
    private let issueRepository: GitHubIssueRepositoryProtocol
    
    init(
        milestoneRepository: GitHubMilestoneRepositoryProtocol,
        issueRepository: GitHubIssueRepositoryProtocol
    ) {
        self.milestoneRepository = milestoneRepository
        self.issueRepository = issueRepository
    }
    
    func execute(owner: String, repo: String, milestone: GitHubMilestone) async throws -> MilestoneDetail {
        // 해당 마일스톤의 모든 이슈들 가져오기 (Open + Closed)
        let allIssues = try await issueRepository.getIssues(owner: owner, repo: repo, state: nil)
        
        // 해당 마일스톤의 이슈들만 필터링
        let milestoneIssues = allIssues.filter { issue in
            issue.milestone?.id == milestone.id
        }
        
        print("🎯 마일스톤 '\(milestone.title)' 이슈 로딩: \(milestoneIssues.count)개")
        
        return MilestoneDetail(milestone: milestone, issues: milestoneIssues)
    }
}
