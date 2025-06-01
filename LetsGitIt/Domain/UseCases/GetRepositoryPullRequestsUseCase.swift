//
//  1.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

final class GetRepositoryPullRequestsUseCase {
    private let pullRequestRepository: GitHubPullRequestRepositoryProtocol
    
    init(pullRequestRepository: GitHubPullRequestRepositoryProtocol) {
        self.pullRequestRepository = pullRequestRepository
    }
    
    func execute(owner: String, repo: String, state: GitHubPullRequestState? = nil) async throws -> [GitHubPullRequest] {
        return try await pullRequestRepository.getPullRequests(owner: owner, repo: repo, state: state)
    }
}
