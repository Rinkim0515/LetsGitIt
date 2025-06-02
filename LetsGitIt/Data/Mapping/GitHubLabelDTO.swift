//
//  1.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

extension GitHubLabelDTO {
    func toDomain() -> GitHubLabel {
        return GitHubLabel(
            id: id,
            name: name,
            color: color,
            description: description
        )
    }
}
