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
}
