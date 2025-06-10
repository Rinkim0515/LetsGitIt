//
//  GitHubCommitRepositoryProtocol.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

protocol GitHubCommitRepositoryProtocol {
    func getCommits(owner: String, repo: String, branch: String?) async throws -> [GitHubCommit]
    func getCommit(owner: String, repo: String, sha: String) async throws -> GitHubCommit
}
