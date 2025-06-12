//
//  AuthCoordinator.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
    func authDidComplete()
}

final class AuthCoordinator: Coordinator {
    var onFinished: (() -> Void)?
    
    var childCoordinators: [Coordinator] = []
    weak var delegate: AuthCoordinatorDelegate?
    
    private let loginViewController: LoginVC
    
    init(loginViewController: LoginVC) {
        self.loginViewController = loginViewController
    }
    
    func start() {
        print("🚀 AuthCoordinator 시작")
        setupLoginViewController()
    }
    
    // MARK: - Setup
    private func setupLoginViewController() {
        loginViewController.coordinator = self
        print("📱 LoginViewController에 coordinator 주입 완료")
    }
    
    // MARK: - Flow Methods (LoginViewController에서 호출)
    func didTapLogin() {
        print("🔐 로그인 버튼 클릭 처리")
        GitHubAuthManager.shared.startOAuthFlow(from: loginViewController)
    }
    
    func authDidComplete() {
        print("✅ AuthCoordinator: 인증 완료")
        delegate?.authDidComplete()
        onFinished?()  // ✅ 완료 알림
    }
    
    func showLoginError(_ error: GitHubAuthError) {
        print("❌ 로그인 에러 표시: \(error.localizedDescription)")
        let alert = UIAlertController(
            title: "로그인 실패",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        loginViewController.present(alert, animated: true)
    }
}
