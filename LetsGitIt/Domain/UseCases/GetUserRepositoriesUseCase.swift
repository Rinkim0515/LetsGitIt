//
//  GetUserRepositoriesUseCase.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

final class GetUserRepositoriesUseCase {
    private let repositoryRepository: GitHubRepositoryRepositoryProtocol
    
    init(repositoryRepository: GitHubRepositoryRepositoryProtocol) {
        self.repositoryRepository = repositoryRepository
    }
    
    func execute() async throws -> [GitHubRepository] {
        return try await repositoryRepository.getUserRepositories()
    }
}
