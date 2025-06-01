//
//  GitHubAPIError.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

enum GitHubAPIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case invalidResponse
    case unauthorized
    case rateLimitExceeded
    case notFound
}

extension GitHubAPIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .noData:
            return "데이터를 받을 수 없습니다."
        case .decodingError:
            return "데이터 파싱에 실패했습니다."
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .invalidResponse:
            return "잘못된 응답입니다."
        case .unauthorized:
            return "인증이 필요합니다."
        case .rateLimitExceeded:
            return "API 호출 한도를 초과했습니다."
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다."
        }
    }
}
