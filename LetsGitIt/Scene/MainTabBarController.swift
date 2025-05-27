//
//  MainTabBarController.swift
//  LetsGitIt
//
//  Created by KimRin on 5/27/25.
//


import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        // 프로필 탭
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: "프로필",
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )
        
        // 레포지토리 탭
        let repoVC = ViewController()
        repoVC.tabBarItem = UITabBarItem(
            title: "레포지토리",
            image: UIImage(systemName: "folder"),
            selectedImage: UIImage(systemName: "folder.fill")
        )
        
        // 네비게이션 컨트롤러로 감싸기
        let profileNav = UINavigationController(rootViewController: profileVC)
        let repoNav = UINavigationController(rootViewController: repoVC)
        
        // 탭바에 설정
        viewControllers = [profileNav, repoNav]
        
        // 탭바 스타일 설정
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
    }
}
