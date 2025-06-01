//
//  GetCurrentUserUseCase.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

final class GetCurrentUserUseCase {
    private let userRepository: GitHubUserRepositoryProtocol
    
    init(userRepository: GitHubUserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute() async throws -> GitHubUser {
        return try await userRepository.getCurrentUser()
    }
}
