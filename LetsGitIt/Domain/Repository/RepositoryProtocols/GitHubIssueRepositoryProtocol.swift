//
//  GitHubIssueRepositoryProtocol.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation


protocol GitHubIssueRepositoryProtocol {
    
    func getIssues(owner: String, repo: String, state: GitHubIssueState?) async throws -> [GitHubIssue]
    
    func getIssue(owner: String, repo: String, number: Int) async throws -> GitHubIssue
    
    func createIssue(owner: String, repo: String, title: String, body: String?) async throws -> GitHubIssue
    
    func updateIssue(owner: String, repo: String, number: Int, title: String?, body: String?, state: GitHubIssueState?) async throws -> GitHubIssue
    
    
}
