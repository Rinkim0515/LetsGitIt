//
//  1.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

final class GetRepositoryMilestonesUseCase {
    private let milestoneRepository: GitHubMilestoneRepositoryProtocol
    
    init(milestoneRepository: GitHubMilestoneRepositoryProtocol) {
        self.milestoneRepository = milestoneRepository
    }
    
    func execute(owner: String, repo: String, state: GitHubMilestoneState? = nil) async throws -> [GitHubMilestone] {
        return try await milestoneRepository.getMilestones(owner: owner, repo: repo, state: state)
    }
}
