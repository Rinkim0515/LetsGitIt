//
//  SettingModel.swift
//  LetsGitIt
//
//  Created by KimRin on 6/3/25.
//


import Foundation

// MARK: - Settings Section
enum SettingsSection: CaseIterable {
    case repository
    case terms
    case version
    
    var items: [SettingsItem] {
        switch self {
        case .repository:
            return [.repositoryDetail, .repositoryChange]
        case .terms:
            return [.termsOfService, .privacyPolicy]
        case .version:
            return [.version]
        }
    }
}

// MARK: - Settings Item
enum SettingsItem {
    case repositoryDetail
    case repositoryChange
    case termsOfService
    case privacyPolicy
    case version
    
    var title: String {
        switch self {
        case .repositoryDetail:
            return "Repository 상세"
        case .repositoryChange:
            return "Repository 변경"
        case .termsOfService:
            return "서비스 이용약관"
        case .privacyPolicy:
            return "개인정보처리방침"
        case .version:
            return "버전"
        }
    }
    
    var hasDisclosure: Bool {
        switch self {
        case .repositoryDetail, .repositoryChange, .termsOfService, .privacyPolicy:
            return true
        case .version:
            return false
        }
    }
    
    var rightText: String? {
        switch self {
        case .version:
            return "v 1.0.0"
        default:
            return nil
        }
    }
}
