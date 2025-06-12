//
//  NetworkContainer.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import Foundation

final class NetworkContainer {
    lazy var gitHubAPIService: GitHubAPIService = {
        return GitHubAPIService()
    }()
}


