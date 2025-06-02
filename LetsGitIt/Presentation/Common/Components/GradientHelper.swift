//
//  GradientHelper.swift
//  LetsGitIt
//
//  Created by KimRin on 6/3/25.
//


import UIKit

// MARK: - Gradient Direction
enum GradientDirection {
    case horizontal  // 좌 → 우
    case vertical    // 위 → 아래
    
    var points: (start: CGPoint, end: CGPoint) {
        switch self {
        case .horizontal:
            return (CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5))
        case .vertical:
            return (CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1))
        }
    }
}

// MARK: - UIView Extension for Gradient
extension UIView {
    
    /// 고정 그라디언트 적용 (C94AFF → 4A5FFF)
    @discardableResult
    func applyBrandGradient(direction: GradientDirection = .horizontal) -> CAGradientLayer {
        let left = UIColor(hex: "C94AFF") ?? .systemPurple  // 보라
        let right = UIColor(hex: "4A5FFF") ?? .systemBlue   // 파랑
        
        return applyGradient(colors: [left, right], direction: direction)
    }
    
    /// 그라디언트 적용
    @discardableResult
    func applyGradient(colors: [UIColor], direction: GradientDirection) -> CAGradientLayer {
        // 기존 그라디언트 레이어 제거
        removeGradientLayer()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        
        let points = direction.points
        gradientLayer.startPoint = points.start
        gradientLayer.endPoint = points.end
        
        // 백그라운드 컬러를 투명으로 설정
        backgroundColor = .clear
        
        // 가장 아래 레이어로 삽입
        layer.insertSublayer(gradientLayer, at: 0)
        
        // 나중에 참조할 수 있도록 이름 설정
        gradientLayer.name = "GradientLayer"
        
        return gradientLayer
    }
    
    /// 그라디언트 레이어 제거
    func removeGradientLayer() {
        layer.sublayers?.removeAll { $0.name == "GradientLayer" }
    }
    
}

// MARK: - 참고사항
/*
 Auto Layout 사용 시 별도 frame 업데이트 불필요
 만약 수동으로 frame을 변경하는 경우에만 아래 메서드 사용:
 
 func updateGradientFrame() {
     if let gradientLayer = layer.sublayers?.first(where: { $0.name == "GradientLayer" }) as? CAGradientLayer {
         gradientLayer.frame = bounds
     }
 }
 */
