//
//  GitHubMilestoneRepository.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import Foundation

final class GitHubMilestoneRepository: GitHubMilestoneRepositoryProtocol {

    
    private let apiService: GitHubAPIService
    
    init(apiService: GitHubAPIService) {
        self.apiService = apiService
    }
    
    func getMilestones(owner: String, repo: String, state: GitHubMilestoneState?) async throws -> [GitHubMilestone] {
        let responses = try await apiService.getMilestones(owner: owner, repo: repo)
        return responses.map { $0.toDomain() }
    }
    
    func getMilestone(owner: String, repo: String, number: Int) async throws -> GitHubMilestone {
        // TODO: 개별 마일스톤 조회 API 추가 필요 시 구현
        throw GitHubAPIError.notFound
    }
    
    func createMilestone(owner: String, repo: String, title: String, description: String?, dueDate: Date?) async throws -> GitHubMilestone {
        // TODO: 마일스톤 생성 API 추가 필요 시 구현
        throw GitHubAPIError.notFound
    }
}
