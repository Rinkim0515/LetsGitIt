//
//  CommentItem.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import Foundation

// MARK: - 코멘트 아이템
struct CommentItem {
    let id: String
    let author: String
    let avatarURL: String?
    let createdAt: Date
    let originalContent: String // 원본 Markdown
    
    // 파싱된 콘텐츠 (lazy 계산 - 필요할 때만 파싱)
    var parsedContent: ParsedContent {
        get {
            return MarkdownParser.parse(originalContent)
        }
    }
}


