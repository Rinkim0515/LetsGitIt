//
//  Extension+UIColor.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import UIKit

extension UIColor {
    
    // MARK: - Brand Colors
    /// 메인 브랜드 컬러 - RGB(74, 95, 255)
    static var brandMain1: UIColor {
        return UIColor(named: "BrandMainColor") ?? .systemBlue
    }
    
    /// 서브 브랜드 컬러 1 - Display P3(167, 171, 200)
    static var brandSub1: UIColor {
        return UIColor(named: "BrandSubColor_1") ?? .systemGray
    }
    
    /// 서브 브랜드 컬러 2 - RGB(254, 76, 144)
    static var brandSub2: UIColor {
        return UIColor(named: "BrandSubColor_2") ?? .systemPink
    }
    
    // MARK: - Background Colors
    /// 메인 배경색 - 라이트: 흰색 / 다크: RGB(52, 52, 65)
    static var backgroundPrimary: UIColor {
        return UIColor(named: "BackgroundColor1") ?? .systemBackground
    }
    
    /// 서브 배경색 - 라이트: 흰색 / 다크: RGB(34, 36, 45)
    static var backgroundSecondary: UIColor {
        return UIColor(named: "BackgroundColor2") ?? .secondarySystemBackground
    }
    
    // MARK: - Text & Content Colors
    /// 비활성화 컬러 - 라이트: 흰색 / 다크: RGB(47, 47, 59)
    static var contentDisabled: UIColor {
        return UIColor(named: "Disable") ?? .systemGray5
    }
    
    /// 서브 컨텐츠 컬러 1 - 라이트: 흰색 / 다크: RGB(114, 118, 150)
    static var contentSub1: UIColor {
        return UIColor(named: "SubColor1") ?? .secondaryLabel
    }
    
    /// 서브 컨텐츠 컬러 2 - 라이트: 흰색 / 다크: RGB(63, 68, 92)
    static var contentSub2: UIColor {
        return UIColor(named: "SubColor2") ?? .tertiaryLabel
    }
    
    // MARK: - Semantic Colors (의미적 컬러)
    /// 카드 배경색
    static var cardBackground: UIColor {
        return subColor2
    }
    
    /// 구분선 색상
    static var separator: UIColor {
        return contentDisabled
    }
    
    /// 메인 텍스트 색상 (라이트모드에서 검정, 다크모드에서 흰색)
    static var textPrimary: UIColor {
        return .label
    }
    
    /// 서브 텍스트 색상
    static var textSecondary: UIColor {
        return contentSub1
    }
    
    /// 비활성 텍스트 색상
    static var textDisabled: UIColor {
        return contentSub2
    }
}


extension UIColor {
    convenience init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
