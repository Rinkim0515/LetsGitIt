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
        print("🎯 GetCurrentUserUseCase 생성됨")
        return GetCurrentUserUseCase(userRepository: repositoryContainer.gitHubUserRepository)
    }()
    
    lazy var getUserRepositoriesUseCase: GetUserRepositoriesUseCase = {
        print("🎯 GetUserRepositoriesUseCase 생성됨")
        return GetUserRepositoriesUseCase(repositoryRepository: repositoryContainer.gitHubRepositoryRepository)
    }()
    
    lazy var getRepositoryMilestonesUseCase: GetRepositoryMilestonesUseCase = {
        print("🎯 GetRepositoryMilestonesUseCase 생성됨")
        return GetRepositoryMilestonesUseCase(milestoneRepository: repositoryContainer.gitHubMilestoneRepository)
    }()
    
    lazy var getRepositoryIssuesUseCase: GetRepositoryIssuesUseCase = {
        print("🎯 GetRepositoryIssuesUseCase 생성됨")
        return GetRepositoryIssuesUseCase(issueRepository: repositoryContainer.gitHubIssueRepository)
    }()
}
