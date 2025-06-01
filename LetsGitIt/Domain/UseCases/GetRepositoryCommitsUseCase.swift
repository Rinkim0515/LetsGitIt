//
//  1.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

final class GetRepositoryCommitsUseCase {
    private let commitRepository: GitHubCommitRepositoryProtocol
    
    init(commitRepository: GitHubCommitRepositoryProtocol) {
        self.commitRepository = commitRepository
    }
    
    func execute(owner: String, repo: String, branch: String? = nil) async throws -> [GitHubCommit] {
        return try await commitRepository.getCommits(owner: owner, repo: repo, branch: branch)
    }
}
