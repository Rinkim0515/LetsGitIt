//
//  NetworkModels.swift
//  LetsGitIt
//
//  Created by KimRin on 5/27/25.
//

// Network/NetworkModels.swift
import Foundation



// MARK: - Error Types
enum GitHubAPIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case invalidResponse
}
