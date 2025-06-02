//
//  Extension+UIView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/3/25.
//

import UIKit

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    // 하단만 둥글게 하는 편의 메서드
    func roundBottomCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

enum GradientDirection {
    case horizontal //좌 -> 우
    case vertical // 위 -> 아래
    
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
        
        // ✅ bounds가 0이면 나중에 설정하도록 대기
        if bounds == .zero {
            // Auto Layout이 완료된 후 적용하도록 예약
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                gradientLayer.frame = self.bounds
            }
        } else {
            gradientLayer.frame = bounds
        }
        
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
        
        // Auto Layout 완료 후 frame 업데이트
        if bounds == .zero {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                gradientLayer.frame = self.bounds
            }
        }
        
        return gradientLayer
    }
    
    /// 그라디언트 레이어 제거
    func removeGradientLayer() {
        layer.sublayers?.removeAll { $0.name == "GradientLayer" }
    }
    
}


