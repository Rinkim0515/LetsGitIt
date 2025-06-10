//
//  GitHubUserRepositoryProtocol.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

protocol GitHubUserRepositoryProtocol {
    func getCurrentUser() async throws -> GitHubUser
    func getUser(login: String) async throws -> GitHubUser
}
