//
//  UIButton+.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import UIKit

// MARK: - UIButton Factory Extensions (레이아웃 안전)
extension UIButton {
    /// 상태 버튼 스타일만 적용 (제약조건 설정 안함)
    static func createStatusButton(title: String, isPositive: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .pretendard(.semiBold, size: 14)
        button.layer.cornerRadius = 16
        
        // 상태에 따른 색상 설정만
        if isPositive {
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .systemGray
            button.setTitleColor(.white, for: .normal)
        }
        
        // 제약조건 설정 제거! (각 화면에서 직접 설정)
        return button
    }
    
    /// Open 상태 버튼
    static func createOpenStatusButton() -> UIButton {
        return createStatusButton(title: "Open", isPositive: true)
    }
    
    /// Closed 상태 버튼
    static func createClosedStatusButton() -> UIButton {
        return createStatusButton(title: "Closed", isPositive: false)
    }
    
    /// 표준 완료 버튼 스타일만 적용
    static func createPrimaryButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .pretendard(.semiBold, size: 16)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        
        return button
    }
    
    /// 표준 보조 버튼 스타일만 적용
    static func createSecondaryButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .pretendard(.regular, size: 16)
        button.backgroundColor = UIColor(named: "SubColor2") ?? .systemGray5
        button.setTitleColor(UIColor(named: "PrimaryText") ?? .label, for: .normal)
        button.layer.cornerRadius = 12
        
        return button
    }
}
