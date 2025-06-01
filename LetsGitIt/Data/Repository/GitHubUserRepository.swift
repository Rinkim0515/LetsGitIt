//
//  GitHubUserRepository.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

final class GitHubUserRepository: GitHubUserRepositoryProtocol {
    private let apiService: GitHubAPIService
    
    init(apiService: GitHubAPIService) {
        self.apiService = apiService
    }
    
    func getCurrentUser() async throws -> GitHubUser {
        let response = try await apiService.getCurrentUser()
        return response.toDomain()
    }
    
    func getUser(login: String) async throws -> GitHubUser {
        let response = try await apiService.getUser(login: login)
        return response.toDomain()
    }
}
