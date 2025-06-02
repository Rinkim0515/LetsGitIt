//
//  Extension+Font.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import UIKit

extension UIFont {
    
    // MARK: - Pretendard Font
    
    enum PretendardWeight {
        case regular
        case medium
        case semiBold
        case bold
        
        var fontName: String {
            switch self {
            case .regular:
                return "Pretendard-Regular"
            case .medium:
                return "Pretendard-Medium"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .bold:
                return "Pretendard-Bold"
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
    
    
    /// 제목용 폰트 (SemiBold, 18pt)
    static var titleFont: UIFont {
        return pretendard(.semiBold, size: 18)
    }
    
    /// 헤더용 폰트 (Bold, 16pt)
    static var headerFont: UIFont {
        return pretendard(.bold, size: 16)
    }
    
    /// 본문용 폰트 (Regular, 14pt)
    static var bodyFont: UIFont {
        return pretendard(.regular, size: 14)
    }
    
    /// 강조용 폰트 (Medium, 14pt)
    static var emphasizedFont: UIFont {
        return pretendard(.medium, size: 14)
    }
    
    /// 캡션용 폰트 (Regular, 12pt)
    static var captionFont: UIFont {
        return pretendard(.regular, size: 12)
    }
}
