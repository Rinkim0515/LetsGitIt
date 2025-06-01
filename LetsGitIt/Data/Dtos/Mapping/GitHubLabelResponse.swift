//
//  1.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

extension GitHubLabelResponse {
    func toDomain() -> GitHubLabel {
        return GitHubLabel(
            id: id,
            name: name,
            color: color,
            description: description
        )
    }
}
