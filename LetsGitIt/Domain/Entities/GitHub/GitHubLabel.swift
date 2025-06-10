//
//  GitHubLabel.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation

import UIKit

struct GitHubLabel {
    let id: Int
    let name: String
    let color: String
    let description: String?
}

extension GitHubLabel {
    
    /// 라벨 색상을 UIColor로 변환
    var uiColor: UIColor {
        return UIColor(hex: color) ?? .systemBlue
    }
    
    /// 라벨 표시용 텍스트 (이름 + 설명)
    var fullDisplayText: String {
        if let description = description, !description.isEmpty {
            return "\(name): \(description)"
        }
        return name
    }
}

extension Array where Element == GitHubLabel {
    
    /// 라벨들을 표시용 텍스트로 변환
    var displayText: String {
        if isEmpty {
            return "없음"
        }
        return map { $0.name }.joined(separator: ", ")
    }
    
    /// 라벨이 없을 때의 색상
    var displayColor: UIColor {
        return isEmpty ? .systemGray : .systemBlue
    }
    
    /// 첫 번째 라벨의 색상 (있는 경우)
    var primaryColor: UIColor? {
        guard let firstLabel = first else { return nil }
        return UIColor(hex: firstLabel.color)
    }
}
