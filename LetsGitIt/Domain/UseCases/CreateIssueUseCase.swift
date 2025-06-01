//
//  2.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation
final class CreateIssueUseCase {
    private let issueRepository: GitHubIssueRepositoryProtocol
    
    init(issueRepository: GitHubIssueRepositoryProtocol) {
        self.issueRepository = issueRepository
    }
    
    func execute(owner: String, repo: String, title: String, body: String?) async throws -> GitHubIssue {
        return try await issueRepository.createIssue(owner: owner, repo: repo, title: title, body: body)
    }
}


