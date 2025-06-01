//
//  GitHubRepositoryResponse.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

extension GitHubRepositoryResponse {
    func toDomain() -> GitHubRepository {
        return GitHubRepository(
            id: id,
            name: name,
            fullName: fullName,
            description: description,
            language: language,
            starCount: stargazersCount,  // API 필드명 → Domain 필드명
            forkCount: forksCount,
            isPrivate: isPrivate,
            owner: owner.toDomain(),  // 중첩 객체도 변환
            updatedAt: ISO8601DateFormatter().date(from: updatedAt) ?? Date()
        )
    }
}
