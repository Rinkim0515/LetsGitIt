//
//  GetRepo.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

final class GetRepositoryDetailsUseCase {
    private let repositoryRepository: GitHubRepositoryRepositoryProtocol
    
    init(repositoryRepository: GitHubRepositoryRepositoryProtocol) {
        self.repositoryRepository = repositoryRepository
    }
    
    func execute(owner: String, name: String) async throws -> GitHubRepository {
        return try await repositoryRepository.getRepository(owner: owner, name: name)
    }
}
