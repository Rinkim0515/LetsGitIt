//
//  SettingsCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

protocol SettingsCoordinatorDelegate: AnyObject {
    func settingsDidRequestLogout()
    func settingsDidChangeRepository()
}

final class SettingsCoordinator: NavigationCoordinator {
    var onFinished: (() -> Void)?
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    weak var delegate: SettingsCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("🚀 SettingsCoordinator 시작")
        showSettings()
    }
    
    // MARK: - Navigation Flow Methods
    private func showSettings() {
        let settingsVC = DIContainer.shared.makeSettingsViewController()
        settingsVC.coordinator = self
        navigationController.setViewControllers([settingsVC], animated: false)
        print("📱 SettingsViewController 설정 완료")
    }
    
    // MARK: - Flow Methods (SettingsViewController에서 호출)
    func showCoreTimeSettings() {
        print("⏰ 코어타임 설정 화면")
        let coreTimeVC = DIContainer.shared.makeCoreTimeSettingsViewController()
        coreTimeVC.coordinator = self
        navigationController.pushViewController(coreTimeVC, animated: true)
    }
    
    func showNotificationSettings() {
        print("🔔 알림 설정 화면")
        let notificationVC = DIContainer.shared.makeNotificationSettingsViewController()
        notificationVC.coordinator = self
        
        // Modal로 표시
        notificationVC.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            notificationVC.sheetPresentationController?.detents = [.medium()]
        }
        navigationController.present(notificationVC, animated: true)
    }
    
    func showWeekdaySelection() {
        print("📅 요일 선택 화면")
        let weekdayVC = DIContainer.shared.makeWeekdaySelectionViewController()
        weekdayVC.coordinator = self
        
        // Modal로 표시
        weekdayVC.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            weekdayVC.sheetPresentationController?.detents = [
                .custom(identifier: .init("weekdays")) { context in
                    return context.maximumDetentValue * 0.7
                }
            ]
        }
        navigationController.present(weekdayVC, animated: true)
    }
    
    func showRepositoryChangeFlow() {
        print("🔄 리포지토리 변경 Flow")
        // 리포지토리 선택 화면으로 이동 (Modal)
        let repositorySelectionVC = DIContainer.shared.makeRepositorySelectionViewController()
        let navController = UINavigationController(rootViewController: repositorySelectionVC)
        
        let repoCoordinator = RepositorySelectionCoordinator(repositorySelectionViewController: repositorySelectionVC)
        repoCoordinator.delegate = self
        
        // ✅ child coordinator 관리
        repoCoordinator.onFinished = { [weak self] in
            self?.childCoordinators.removeAll { $0 === repoCoordinator }
            print("✅ RepositorySelectionCoordinator 메모리 해제됨")
        }
        
        childCoordinators.append(repoCoordinator)
        repoCoordinator.start()
        
        navigationController.present(navController, animated: true)
    }
    
    func showTermsOfService() {
        print("📄 서비스 이용약관")
        // 웹뷰나 텍스트 화면으로 표시
    }
    
    func showPrivacyPolicy() {
        print("🔒 개인정보처리방침")
        // 웹뷰나 텍스트 화면으로 표시
    }
    
    func requestLogout() {
        print("🚪 로그아웃 요청")
        delegate?.settingsDidRequestLogout()
    }
    
    func dismissModal() {
        print("📱 Modal 닫기")
        navigationController.dismiss(animated: true)
    }
    
    func navigateBackToSettings() {
        print("⚙️ 설정으로 돌아가기")
        navigationController.popToRootViewController(animated: true)
    }
}

// MARK: - Repository Selection Delegate
extension SettingsCoordinator: RepositorySelectionCoordinatorDelegate {
    func repositorySelectionDidComplete() {
        print("✅ 설정에서 리포지토리 변경 완료")
        childCoordinators.removeAll()
        dismissModal()
        delegate?.settingsDidChangeRepository()
    }
}
