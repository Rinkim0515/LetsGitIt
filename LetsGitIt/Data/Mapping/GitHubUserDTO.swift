//
//  GitHubUserResponse.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

extension GitHubUserDTO {
    func toDomain() -> GitHubUser {
        return GitHubUser(
            id: id,
            login: login,
            name: name,
            avatarURL: avatarUrl,
            bio: bio,
            publicRepos: publicRepos ?? 0,    // ✅ 기본값 0
            followers: followers ?? 0,        // ✅ 기본값 0
            following: following ?? 0         // ✅ 기본값 0
        )
    }
}
