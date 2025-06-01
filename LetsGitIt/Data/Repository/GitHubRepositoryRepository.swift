//
//  GitHubRepositoryRepository.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

final class GitHubRepositoryRepository: GitHubRepositoryRepositoryProtocol {
    private let apiService: GitHubAPIService
    
    init(apiService: GitHubAPIService) {
        self.apiService = apiService
    }
    
    func getUserRepositories() async throws -> [GitHubRepository] {
        let responses = try await apiService.getUserRepositories()
        return responses.map { $0.toDomain() }
    }
    
    func getRepository(owner: String, name: String) async throws -> GitHubRepository {
        let response = try await apiService.getRepository(owner: owner, name: name)
        return response.toDomain()
    }
    
    func getRepositoryLanguages(owner: String, name: String) async throws -> [String: Int] {
        return try await apiService.getRepositoryLanguages(owner: owner, name: name)
    }
    
    func getRepositoryContributors(owner: String, name: String) async throws -> [GitHubUser] {
        let responses = try await apiService.getRepositoryContributors(owner: owner, name: name)
        return responses.map { $0.toDomain() }
    }
}
