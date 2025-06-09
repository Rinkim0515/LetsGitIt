//
//  Extension+Font.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import UIKit

extension UIFont {
    
    // MARK: - Pretendard Font (3가지 고정)
    
    enum PretendardWeight {
        case light
        case regular
        case semiBold
        
        var fontName: String {
            switch self {
            case .light:
                return "Pretendard-Light"
            case .regular:
                return "Pretendard-Regular"
            case .semiBold:
                return "Pretendard-SemiBold"
            }
        }
    }
    
    static func pretendard(_ weight: PretendardWeight, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: weight.fontName, size: size) else {
            print("⚠️ Pretendard 폰트를 찾을 수 없습니다: \(weight.fontName)")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    // MARK: - 편의 메서드 (GitHub 앱용 - 3가지 폰트 활용)
    
    /// 제목용 폰트 (SemiBold, 18pt)
    static var titleFont: UIFont {
        return pretendard(.semiBold, size: 18)
    }
    
    /// 헤더용 폰트 (SemiBold, 16pt)
    static var headerFont: UIFont {
        return pretendard(.semiBold, size: 16)
    }
    
    /// 본문용 폰트 (Regular, 14pt)
    static var bodyFont: UIFont {
        return pretendard(.regular, size: 14)
    }
    
    /// 강조용 폰트 (SemiBold, 14pt)
    static var emphasizedFont: UIFont {
        return pretendard(.semiBold, size: 14)
    }
    
    /// 캡션용 폰트 (Light, 12pt)
    static var captionFont: UIFont {
        return pretendard(.light, size: 12)
    }
    
    /// 가벼운 텍스트용 폰트 (Light, 14pt)
    static var lightFont: UIFont {
        return pretendard(.light, size: 14)
    }
}
