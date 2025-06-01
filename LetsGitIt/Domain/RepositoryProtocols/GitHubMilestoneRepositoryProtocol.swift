//
//  GitHubMilestoneRepositoryProtocol.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

protocol GitHubMilestoneRepositoryProtocol {
    func getMilestones(owner: String, repo: String, state: GitHubMilestoneState?) async throws -> [GitHubMilestone]
    func getMilestone(owner: String, repo: String, number: Int) async throws -> GitHubMilestone
    func createMilestone(owner: String, repo: String, title: String, description: String?, dueDate: Date?) async throws -> GitHubMilestone
}
