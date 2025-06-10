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
    
    // HomeVC용: 현재 시점과 가장 가까운 마일스톤 2개
    func executeForHome(owner: String, repo: String) async throws -> [GitHubMilestone] {
        let milestones = try await milestoneRepository.getMilestones(owner: owner, repo: repo, state: .open)
        
        // 현재 시점과 가장 가까운 순으로 정렬
        let now = Date()
        let sortedMilestones = milestones.sorted { milestone1, milestone2 in
            let diff1 = abs(milestone1.dueDate?.timeIntervalSince(now) ?? Double.greatestFiniteMagnitude)
            let diff2 = abs(milestone2.dueDate?.timeIntervalSince(now) ?? Double.greatestFiniteMagnitude)
            return diff1 < diff2
        }
        
        return Array(sortedMilestones.prefix(2)) // 2개만 반환
    }
}
