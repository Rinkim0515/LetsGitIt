//
//  AllRepositoryCoordinator.swift - 수정된 부분
//

import UIKit

final class RepositoryListCoordinator: NavigationCoordinator {
    var childCoordinators: [Coordinator] = []
    var onFinished: (() -> Void)?  // ✅ 추가
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showAllRepositories()
    }
    
    // MARK: - Navigation Flow Methods
    private func showAllRepositories() {
        let allRepositoryVC = DIContainer.shared.makeAllRepositoryViewController()
        allRepositoryVC.coordinator = self
        navigationController.setViewControllers([allRepositoryVC], animated: false)
    }
    
    // MARK: - Flow Methods (AllRepositoryViewController에서 호출)
    func showRepositoryDetail(_ repository: GitHubRepository) {
        print("📁 리포지토리 상세 화면: \(repository.name)")
        
        let repositoryDetailCoordinator = RepositoryDetailCoordinator(
            navigationController: navigationController,
            repository: repository
        )
        
        // ✅ 완료 시 child에서 제거
        repositoryDetailCoordinator.onFinished = { [weak self] in
            self?.childCoordinators.removeAll { $0 === repositoryDetailCoordinator }
            print("✅ RepositoryDetailCoordinator 메모리 해제됨")
        }
        
        childCoordinators.append(repositoryDetailCoordinator)
        repositoryDetailCoordinator.start()
    }
    
    func navigateBackToRepositoryList() {
        navigationController.popViewController(animated: true)
    }
    
    func dismissRepositoryDetail() {
        print("📱 리포지토리 상세 닫기")
        navigationController.popViewController(animated: true)
    }
}
