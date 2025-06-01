//
//  GitHubUserResponse.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

extension GitHubUserResponse {
    func toDomain() -> GitHubUser {
        return GitHubUser(
            id: id,
            login: login,
            name: name,
            avatarURL: avatarUrl,  // API의 snake_case → Domain의 camelCase
            bio: bio,
            publicRepos: publicRepos,
            followers: followers,
            following: following
        )
    }
}
