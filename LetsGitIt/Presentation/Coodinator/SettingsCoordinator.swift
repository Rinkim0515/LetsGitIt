//
//  SettingsCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

protocol SettingsCoordinatorDelegate: AnyObject {
    func settingsDidRequestLogout()
}

final class SettingsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: SettingsCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let settingsVC = SettingViewController()
        settingsVC.coordinator = self
        navigationController.setViewControllers([settingsVC], animated: false)
    }
    
    func logout() {
        delegate?.settingsDidRequestLogout()
    }
}
