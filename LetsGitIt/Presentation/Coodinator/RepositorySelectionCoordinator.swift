//
//  RepositorySelectionCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

protocol RepositorySelectionCoordinatorDelegate: AnyObject {
    func repositorySelectionDidComplete()
}

final class RepositorySelectionCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var delegate: RepositorySelectionCoordinatorDelegate?
    
    private let repositorySelectionViewController: RepositorySelectionViewController
    
    init(repositorySelectionViewController: RepositorySelectionViewController) {
        self.repositorySelectionViewController = repositorySelectionViewController
    }
    
    func start() {
        print("🚀 RepositorySelectionCoordinator 시작")
        setupRepositorySelectionViewController()
    }
    
    // MARK: - Setup
    private func setupRepositorySelectionViewController() {
        // ✅ 업계 표준: Coordinator를 ViewController에 주입
        repositorySelectionViewController.coordinator = self
        print("📱 RepositorySelectionViewController에 coordinator 주입 완료")
    }
    
    // MARK: - Flow Methods (RepositorySelectionViewController에서 호출)
    func didSelectRepository(_ repository: GitHubRepository) {
        print("✅ 리포지토리 선택됨: \(repository.fullName)")
        saveSelectedRepository(repository)
        delegate?.repositorySelectionDidComplete()
    }
    
    func didTapSearch(_ searchText: String) {
        print("🔍 검색 요청: \(searchText)")
        // 필요시 검색 결과 화면 표시 로직 (현재는 단순 필터링)
    }
    
    func showRepositoryDetail(_ repository: GitHubRepository) {
        print("📍 리포지토리 상세 화면 표시: \(repository.name)")
        // 필요시 Modal로 상세 화면 표시
        let repositoryDetailVC = DIContainer.shared.makeRepositoryDetailViewController(repository: repository)
        
        repositorySelectionViewController.present(repositoryDetailVC, animated: true)
    }
    
    func dismissRepositoryDetail() {
        print("📱 리포지토리 상세 화면 닫기")
        repositorySelectionViewController.dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    private func saveSelectedRepository(_ repository: GitHubRepository) {
        UserDefaults.standard.set(repository.name, forKey: "selected_repository_name")
        UserDefaults.standard.set(repository.owner.login, forKey: "selected_repository_owner")
        print("💾 선택된 리포지토리 저장 완료")
    }
}
