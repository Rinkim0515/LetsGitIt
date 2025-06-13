//
//  GitHubIssueRepository.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import Foundation

final class GitHubIssueRepository: GitHubIssueRepositoryProtocol {
    private let apiService: GitHubAPIService
    
    init(apiService: GitHubAPIService) {
        self.apiService = apiService
    }
    
    func getIssues(owner: String, repo: String, state: GitHubIssueState?) async throws -> [GitHubIssue] {
        // ✅ state 파라미터를 API 호출에 전달
        let apiState: String?
        switch state {
        case .open:
            apiState = "open"
        case .closed:
            apiState = "closed"
        case .none:
            apiState = "all" // ✅ nil일 때 모든 이슈 가져오기
        }
        
        let responses = try await apiService.getIssues(owner: owner, repo: repo, state: apiState)
        return responses.map { $0.toDomain() }
    }
    
    
    
    func getIssue(owner: String, repo: String, number: Int) async throws -> GitHubIssue {
        // TODO: 개별 이슈 조회 API 추가 필요 시 구현
        throw GitHubAPIError.notFound
    }
    
    func createIssue(owner: String, repo: String, title: String, body: String?) async throws -> GitHubIssue {
        // TODO: 이슈 생성 API 추가 필요 시 구현
        throw GitHubAPIError.notFound
    }
    
    func updateIssue(owner: String, repo: String, number: Int, title: String?, body: String?, state: GitHubIssueState?) async throws -> GitHubIssue {
        // TODO: 이슈 업데이트 API 추가 필요 시 구현
        throw GitHubAPIError.notFound
    }
}
