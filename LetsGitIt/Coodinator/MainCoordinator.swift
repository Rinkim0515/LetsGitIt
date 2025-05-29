//
//  MainCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 5/29/25.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}


