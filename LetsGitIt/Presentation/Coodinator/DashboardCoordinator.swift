//
//  DashboardCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

final class DashboardCoordinator: NavigationCoordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("🚀 DashboardCoordinator 시작")
        showDashboard()
    }
    
    // MARK: - Navigation Flow Methods
    private func showDashboard() {
        let dashboardVC = DIContainer.shared.makeDashboardViewController()
        dashboardVC.coordinator = self
        navigationController.setViewControllers([dashboardVC], animated: false)
        print("📱 DashboardViewController 설정 완료")
    }
    
    // MARK: - Flow Methods (DashboardViewController에서 호출)
    func showDetailedStats() {
        print("📊 상세 통계 화면으로 이동")
        // 필요시 상세 통계 화면 구현
    }
    
    func showCalendarDetail(_ date: Date) {
        print("📅 날짜별 상세 정보: \(date)")
        // 필요시 특정 날짜 상세 화면 구현
    }
    
    func showWeeklyReport() {
        print("📈 주간 리포트 화면")
        // 필요시 주간 리포트 화면 구현
    }
    
    func navigateBackToDashboard() {
        print("📊 대시보드로 돌아가기")
        navigationController.popToRootViewController(animated: true)
    }
}

