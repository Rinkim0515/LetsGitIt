//
//  GitHubAPIService.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

final class GitHubAPIService {
    private let baseURL = "https://api.github.com"
    private let session = URLSession.shared
    
    private var headers: [String: String] {
        guard let token = UserDefaults.standard.string(forKey: "github_access_token") else {
            return [:]
        }
        return ["Authorization": "Bearer \(token)"]
    }
    
    private func createRequest(for endpoint: String) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    // MARK: - User API
    func getCurrentUser() async throws -> GitHubUserDTO {
        guard let request = createRequest(for: "/user") else {
            throw GitHubAPIError.invalidURL
        }
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(GitHubUserDTO.self, from: data)
    }
    
    func getUser(login: String) async throws -> GitHubUserDTO {
        guard let request = createRequest(for: "/users/\(login)") else {
            throw GitHubAPIError.invalidURL
        }
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(GitHubUserDTO.self, from: data)
    }
    
    // MARK: - Repository API
    func getUserRepositories() async throws -> [GitHubRepositoryDTO] {
        guard let request = createRequest(for: "/user/repos") else {
            throw GitHubAPIError.invalidURL
        }
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode([GitHubRepositoryDTO].self, from: data)
    }
    
    func getRepository(owner: String, name: String) async throws -> GitHubRepositoryDTO {
        guard let request = createRequest(for: "/repos/\(owner)/\(name)") else {
            throw GitHubAPIError.invalidURL
        }
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(GitHubRepositoryDTO.self, from: data)
    }
    
    func getRepositoryLanguages(owner: String, name: String) async throws -> [String: Int] {
        guard let request = createRequest(for: "/repos/\(owner)/\(name)/languages") else {
            throw GitHubAPIError.invalidURL
        }
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode([String: Int].self, from: data)
    }
    
    func getRepositoryContributors(owner: String, name: String) async throws -> [GitHubUserDTO] {
        guard let request = createRequest(for: "/repos/\(owner)/\(name)/contributors") else {
            throw GitHubAPIError.invalidURL
        }
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode([GitHubUserDTO].self, from: data)
    }
}
