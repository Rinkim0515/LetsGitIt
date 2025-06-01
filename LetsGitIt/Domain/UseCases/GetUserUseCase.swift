//
//  GetUserUseCase.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

final class GetUserUseCase {
    private let userRepository: GitHubUserRepositoryProtocol
    
    init(userRepository: GitHubUserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(login: String) async throws -> GitHubUser {
        return try await userRepository.getUser(login: login)
    }
}
