////
////  GitHubAPIManager.swift
////  LetsGitIt
////
////  Created by KimRin on 5/27/25.
////
//
//// Network/GitHubAPIManager.swift
//import Foundation
//
//class GitHubAPIManager {
//    static let shared = GitHubAPIManager()
//    
//    private let baseURL = "https://api.github.com"
//    private let session = URLSession.shared
//    
//    private init() {}
//    
//    // MARK: - Private Methods
//    private var headers: [String: String] {
//        guard let token = UserDefaults.standard.string(forKey: "github_access_token") else {
//            return [:]
//        }
//        return ["Authorization": "Bearer \(token)"]
//    }
//    
//    private func createRequest(for endpoint: String) -> URLRequest? {
//        guard let url = URL(string: "\(baseURL)\(endpoint)") else { return nil }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        for (key, value) in headers {
//            request.setValue(value, forHTTPHeaderField: key)
//        }
//        
//        return request
//    }
//    
//    // MARK: - User API
//    func getCurrentUser(completion: @escaping (Result<GitHubUser, GitHubAPIError>) -> Void) {
//        guard let request = createRequest(for: "/user") else {
//            completion(.failure(.invalidURL))
//            return
//        }
//        
//        session.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    completion(.failure(.networkError(error)))
//                    return
//                }
//                
//                guard let data = data else {
//                    completion(.failure(.noData))
//                    return
//                }
//                
//                do {
//                    let user = try JSONDecoder().decode(GitHubUser.self, from: data)
//                    completion(.success(user))
//                } catch {
//                    completion(.failure(.decodingError))
//                }
//            }
//        }.resume()
//    }
//    
//    // MARK: - Repository API
//    func getUserRepositories(completion: @escaping (Result<[GitHubRepository], GitHubAPIError>) -> Void) {
//        guard let request = createRequest(for: "/user/repos") else {
//            completion(.failure(.invalidURL))
//            return
//        }
//        
//        session.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    completion(.failure(.networkError(error)))
//                    return
//                }
//                
//                guard let data = data else {
//                    completion(.failure(.noData))
//                    return
//                }
//                
//                do {
//                    let repos = try JSONDecoder().decode([GitHubRepository].self, from: data)
//                    completion(.success(repos))
//                } catch {
//                    completion(.failure(.decodingError))
//                }
//            }
//        }.resume()
//    }
//}
