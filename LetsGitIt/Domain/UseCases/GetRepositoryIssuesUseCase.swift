//
//  1.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

final class GetRepositoryIssuesUseCase {
    private let issueRepository: GitHubIssueRepositoryProtocol
    
    init(issueRepository: GitHubIssueRepositoryProtocol) {
        self.issueRepository = issueRepository
    }
    
    func execute(owner: String, repo: String, state: GitHubIssueState? = nil) async throws -> [GitHubIssue] {
        return try await issueRepository.getIssues(owner: owner, repo: repo, state: state)
    }
    
    func executeForAllIssues(owner: String, repo: String) async throws -> [GitHubIssue] {
        return try await issueRepository.getIssues(owner: owner, repo: repo, state: nil)
    }
    
    // HomeVC용: 업데이트가 가장 오래된 미완료 이슈 4개
    func executeForHome(owner: String, repo: String) async throws -> [GitHubIssue] {
        let issues = try await issueRepository.getIssues(owner: owner, repo: repo, state: .open)
        
        // 업데이트가 가장 오래된 순으로 정렬
        let sortedIssues = issues.sorted { $0.updatedAt < $1.updatedAt }
        
        return Array(sortedIssues.prefix(4)) // 4개만 반환
    }
}
