//
//  RepositoryContainer.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import Foundation

final class RepositoryContainer {
    private let networkContainer: NetworkContainer
    
    init(networkContainer: NetworkContainer) {
        self.networkContainer = networkContainer
    }
    
    lazy var gitHubUserRepository: GitHubUserRepositoryProtocol = {
        print("📦 GitHubUserRepository 생성됨")
        return GitHubUserRepository(apiService: networkContainer.gitHubAPIService)
    }()
    
    lazy var gitHubRepositoryRepository: GitHubRepositoryRepositoryProtocol = {
        print("📦 GitHubRepositoryRepository 생성됨")
        return GitHubRepositoryRepository(apiService: networkContainer.gitHubAPIService)
    }()
    
    lazy var gitHubMilestoneRepository: GitHubMilestoneRepositoryProtocol = {
        print("📦 GitHubMilestoneRepository 생성됨")
        return GitHubMilestoneRepository(apiService: networkContainer.gitHubAPIService)
    }()
    
    lazy var gitHubIssueRepository: GitHubIssueRepositoryProtocol = {
        print("📦 GitHubIssueRepository 생성됨")
        return GitHubIssueRepository(apiService: networkContainer.gitHubAPIService)
    }()
}
