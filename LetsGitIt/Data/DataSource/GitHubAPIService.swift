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
            print("❌ Access Token이 없습니다")
            return [:]
        }
        print("✅ Access Token 존재: \(token.prefix(10))...")
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
        print("🔧 getUserRepositories 호출됨")
        
        guard let request = createRequest(for: "/user/repos") else {
            print("❌ 잘못된 URL")
            throw GitHubAPIError.invalidURL
        }
        
        // 헤더 확인
        print("📋 요청 헤더: \(request.allHTTPHeaderFields ?? [:])")
        print("📍 요청 URL: \(request.url?.absoluteString ?? "없음")")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // HTTP 응답 상태 확인
            if let httpResponse = response as? HTTPURLResponse {
                print("📈 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode != 200 {
                    print("❌ HTTP 오류 응답: \(httpResponse.statusCode)")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("응답 내용: \(responseString)")
                    }
                }
            }
            
            let repositories = try JSONDecoder().decode([GitHubRepositoryDTO].self, from: data)
            print("✅ 리포지토리 \(repositories.count)개 로드됨")
            return repositories
            
        } catch {
            print("❌ API 호출 오류: \(error)")
            throw GitHubAPIError.networkError(error)
        }
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
    
    
    // MARK: - Milestone API
    func getMilestones(owner: String, repo: String) async throws -> [GitHubMilestoneDTO] {
        guard let request = createRequest(for: "/repos/\(owner)/\(repo)/milestones?state=open") else {
            throw GitHubAPIError.invalidURL
        }
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode([GitHubMilestoneDTO].self, from: data)
    }

    // MARK: - Issue API
    func getIssues(owner: String, repo: String) async throws -> [GitHubIssueDTO] {
        guard let request = createRequest(for: "/repos/\(owner)/\(repo)/issues?state=open&sort=updated&direction=asc") else {
            throw GitHubAPIError.invalidURL
        }
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode([GitHubIssueDTO].self, from: data)
    }
}
