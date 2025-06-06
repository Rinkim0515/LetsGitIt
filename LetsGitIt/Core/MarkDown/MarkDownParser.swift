//
//  MarkDownParser.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import Foundation
import Down

// MARK: - 이미지 정보
struct ImageInfo {
    let url: String         // 이미지 URL
    let altText: String     // 대체 텍스트
}

// MARK: - 파싱 결과 (간소화)
struct ParsedContent {
    let hasText: Bool                          // 텍스트 있는지 여부
    let attributedText: NSAttributedString?    // Down으로 렌더링된 텍스트
    let images: [ImageInfo]                    // 이미지 배열 (0개 이상)
    let originalMarkdown: String               // 원본 마크다운
}

// MARK: - Markdown 파서 (간소화)
final class MarkdownParser {
    
    /// 메인 파싱 함수
    static func parse(_ markdown: String) -> ParsedContent {
        do {
            // 1. Down으로 HTML 변환
            let down = Down(markdownString: markdown)
            let html = try down.toHTML()
            
            // 2. HTML에서 이미지 추출
            let images = extractImages(from: html)
            
            // 3. 이미지 제거한 마크다운으로 AttributedString 생성
            let cleanMarkdown = removeImageMarkdown(from: markdown)
            let attributedText = try? Down(markdownString: cleanMarkdown).toAttributedString()
            
            // 4. 텍스트 있는지 확인 (간단하게)
            let hasText = !cleanMarkdown.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            
            return ParsedContent(
                hasText: hasText,
                attributedText: attributedText,
                images: images,
                originalMarkdown: markdown
            )
            
        } catch {
            // 에러 시 기본 처리
            return ParsedContent(
                hasText: true,
                attributedText: NSAttributedString(string: markdown),
                images: [],
                originalMarkdown: markdown
            )
        }
    }
}

// MARK: - 파싱 도우미 함수들
extension MarkdownParser {
    
    /// HTML에서 이미지 태그 찾아서 추출
    private static func extractImages(from html: String) -> [ImageInfo] {
        let pattern = "<img[^>]+src=[\"']([^\"']+)[\"'][^>]*(?:alt=[\"']([^\"']*)[\"'])?[^>]*>"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return []
        }
        
        let range = NSRange(html.startIndex..., in: html)
        let matches = regex.matches(in: html, options: [], range: range)
        
        return matches.compactMap { match in
            guard match.numberOfRanges >= 2,
                  let urlRange = Range(match.range(at: 1), in: html) else {
                return nil
            }
            
            let url = String(html[urlRange])
            
            let altText: String
            if match.numberOfRanges >= 3,
               let altRange = Range(match.range(at: 2), in: html) {
                altText = String(html[altRange])
            } else {
                altText = ""
            }
            
            return ImageInfo(url: url, altText: altText)
        }
    }
    
    /// 마크다운에서 이미지 구문 제거
    private static func removeImageMarkdown(from markdown: String) -> String {
        let pattern = "!\\[([^\\]]*)\\]\\(([^\\)]*)\\)"
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return markdown
        }
        
        let range = NSRange(markdown.startIndex..., in: markdown)
        let result = regex.stringByReplacingMatches(
            in: markdown,
            options: [],
            range: range,
            withTemplate: ""
        )
        
        return result
            .replacingOccurrences(of: "\n\n+", with: "\n\n", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
