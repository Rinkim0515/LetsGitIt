//
//  DIContainer.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import Foundation
import UIKit

final class DIContainer {
    static let shared = DIContainer()
    
    // MARK: - 레이어별 컨테이너들 (내부 관리)
    private lazy var networkContainer = NetworkContainer()
    private lazy var repositoryContainer = RepositoryContainer(networkContainer: networkContainer)
    private lazy var useCaseContainer = UseCaseContainer(repositoryContainer: repositoryContainer)
    private lazy var viewControllerContainer = ViewControllerContainer(useCaseContainer: useCaseContainer)
    
    private init() {}
    
    // MARK: - Auth Flow ViewControllers
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController()
    }
    
    // MARK: - Repository Selection Flow ViewControllers
    func makeRepositorySelectionViewController() -> RepositorySelectionViewController {
        return viewControllerContainer.makeRepositorySelectionViewController()
    }
    
    // MARK: - Main Flow ViewControllers (TabBar + Navigation)
    func makeMainTabBarController() -> MainTabBarController {
        return viewControllerContainer.makeMainTabBarController()
    }
    
    // MARK: - Home Tab ViewControllers
    func makeHomeViewController() -> HomeViewController {
        // ✅ coordinator는 나중에 설정되므로 UseCase만 주입
        return HomeViewController(
            getCurrentUserUseCase: useCaseContainer.getCurrentUserUseCase,
            getMilestonesUseCase: useCaseContainer.getRepositoryMilestonesUseCase,
            getIssuesUseCase: useCaseContainer.getRepositoryIssuesUseCase
        )
    }
    
    func makeIssueDetailViewController(issue: GitHubIssue) -> IssueDetailViewController {
        return IssueDetailViewController(issue: issue)
    }
    
    func makeMilestoneDetailViewController(milestone: GitHubMilestone) -> MilestoneDetailViewController {
        // Mock 데이터 사용 (실제로는 milestone detail UseCase 필요)
        return MilestoneDetailViewController(mockData: MockMilestoneDetail.sample)
    }
    
    // MARK: - Dashboard Tab ViewControllers
    func makeDashboardViewController() -> DashboardViewController {
        return viewControllerContainer.makeDashboardVC()
    }
    
    // MARK: - Repository Tab ViewControllers
    func makeAllRepositoryViewController() -> RepositroyListViewController {
        return viewControllerContainer.makeAllRepositoryVC()
    }
    
    func makeRepositoryDetailViewController(repository: GitHubRepository) -> RepositoryDetailViewController {
        return RepositoryDetailViewController(repository: repository)
    }
    
    // MARK: - Settings Tab ViewControllers
    func makeSettingsViewController() -> SettingViewController {
        return SettingViewController()
    }
    
    func makeCoreTimeSettingsViewController() -> TimePickerViewController {
        let currentTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
        return TimePickerViewController(title: "코어타임 설정", initialTime: currentTime)
    }
    
    func makeNotificationSettingsViewController() -> NotificationSettingViewController {
        return NotificationSettingViewController(selectedOption: .none)
    }
    
    func makeWeekdaySelectionViewController() -> WeekdaySelectionViewController {
        return WeekdaySelectionViewController(selectedDays: [])
    }
}
