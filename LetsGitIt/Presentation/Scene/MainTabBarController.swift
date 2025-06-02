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

// MARK: - 임시 RepositoryListViewController
final class RepositoryListViewController: UIViewController {
    private let getUserRepositoriesUseCase: GetUserRepositoriesUseCase
    
    init(getUserRepositoriesUseCase: GetUserRepositoriesUseCase) {
        self.getUserRepositoriesUseCase = getUserRepositoriesUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "레포지토리"
        view.backgroundColor = .systemBackground
        
        // TODO: 나중에 제대로 구현
        let label = UILabel()
        label.text = "레포지토리 목록\n(Clean Architecture 적용 완료!)"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
