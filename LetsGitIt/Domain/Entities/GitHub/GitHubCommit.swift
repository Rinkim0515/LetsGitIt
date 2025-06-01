//
//  GitHubCommit.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

struct GitHubCommit {
    let sha: String
    let message: String
    let author: GitHubCommitAuthor
    let committer: GitHubCommitAuthor
    let additions: Int
    let deletions: Int
    let timestamp: Date
}

struct GitHubCommitAuthor {
    let name: String
    let email: String
    let date: Date
}
