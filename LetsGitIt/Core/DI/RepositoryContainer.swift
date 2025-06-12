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
        return GitHubUserRepository(apiService: networkContainer.gitHubAPIService)
    }()
    
    lazy var gitHubRepositoryRepository: GitHubRepositoryRepositoryProtocol = {
        return GitHubRepositoryRepository(apiService: networkContainer.gitHubAPIService)
    }()
    
    lazy var gitHubMilestoneRepository: GitHubMilestoneRepositoryProtocol = {
        return GitHubMilestoneRepository(apiService: networkContainer.gitHubAPIService)
    }()
    
    lazy var gitHubIssueRepository: GitHubIssueRepositoryProtocol = {
        return GitHubIssueRepository(apiService: networkContainer.gitHubAPIService)
    }()
}
