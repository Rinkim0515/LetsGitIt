//
//  GitHubPullRequestRepositoryProtocol.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

protocol GitHubPullRequestRepositoryProtocol {
    func getPullRequests(owner: String, repo: String, state: GitHubPullRequestState?) async throws -> [GitHubPullRequest]
    func getPullRequest(owner: String, repo: String, number: Int) async throws -> GitHubPullRequest
}
