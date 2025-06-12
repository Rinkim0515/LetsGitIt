//
//  USe.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import Foundation

final class UseCaseContainer {
    private let repositoryContainer: RepositoryContainer
    
    init(repositoryContainer: RepositoryContainer) {
        self.repositoryContainer = repositoryContainer
    }
    
    lazy var getCurrentUserUseCase: GetCurrentUserUseCase = {
        return GetCurrentUserUseCase(userRepository: repositoryContainer.gitHubUserRepository)
    }()
    
    lazy var getUserRepositoriesUseCase: GetUserRepositoriesUseCase = {
        return GetUserRepositoriesUseCase(repositoryRepository: repositoryContainer.gitHubRepositoryRepository)
    }()
    
    lazy var getRepositoryMilestonesUseCase: GetRepositoryMilestonesUseCase = {
        return GetRepositoryMilestonesUseCase(milestoneRepository: repositoryContainer.gitHubMilestoneRepository)
    }()
    
    lazy var getRepositoryIssuesUseCase: GetRepositoryIssuesUseCase = {
        return GetRepositoryIssuesUseCase(issueRepository: repositoryContainer.gitHubIssueRepository)
    }()
}
