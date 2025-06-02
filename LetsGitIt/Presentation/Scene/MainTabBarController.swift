//
//  MainTabBarController.swift
//  LetsGitIt
//
//  Created by KimRin on 5/27/25.
//


import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarStyle()
    }
    
    private func setupTabBarStyle() {
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .cardBackground
        
        // 모든 상태에서 동일한 스타일 적용
        tabBar.standardAppearance = appearance       // 기본 상태
        tabBar.scrollEdgeAppearance = appearance     // 스크롤 시
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance // iOS 15+
        }
        tabBar.tintColor = .systemBlue
        tabBar.isTranslucent = false
        
    }
}


