//
//  GitHubRepositoryRepositoryProtocol.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

protocol GitHubRepositoryRepositoryProtocol {
    func getUserRepositories() async throws -> [GitHubRepository]
    func getRepository(owner: String, name: String) async throws -> GitHubRepository
    func getRepositoryLanguages(owner: String, name: String) async throws -> [String: Int]
    func getRepositoryContributors(owner: String, name: String) async throws -> [GitHubUser]
}
