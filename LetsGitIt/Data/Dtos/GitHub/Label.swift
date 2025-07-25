//
//  GitHubLabelResponse.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

struct GitHubLabelDTO: Codable {
    let id: Int
    let name: String
    let color: String
    let description: String?
}
