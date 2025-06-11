//
//  SceneDelegate.swift
//  LetsGitIt
//
//  Created by KimRin on 5/27/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // ✅ Coordinator 패턴 적용
        guard let window = window else { return }
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        if url.scheme == "letsgitit" {
            GitHubAuthManager.shared.handleCallback(url: url) { [weak self] result in
                switch result {
                case .success(let token):
                    print("✅ 로그인 성공: \(token)")
                    self?.handleAuthenticationSuccess()
                    
                case .failure(let error):
                    print("❌ 로그인 실패: \(error)")
                    self?.handleAuthenticationFailure(error)
                }
            }
        }
    }
    
    private func findCurrentLoginViewController() -> LoginViewController? {
        guard let appCoordinator = self.appCoordinator else {
            print("❌ AppCoordinator 없음")
            return nil
        }
        
        // AuthCoordinator 찾기
        guard let authCoordinator = appCoordinator.childCoordinators.first(where: { $0 is AuthCoordinator }) as? AuthCoordinator else {
            print("❌ AuthCoordinator 없음")
            return nil
        }
        
        // 현재 보여지는 LoginViewController 찾기
        guard let loginVC = authCoordinator.navigationController.topViewController as? LoginViewController else {
            print("❌ LoginViewController 없음")
            return nil
        }
        
        print("✅ LoginViewController 찾음")
        return loginVC
    }
    
    private func notifyAppCoordinatorDirectly() {
        // ✅ LoginViewController를 찾을 수 없는 경우 대안
        // AuthCoordinator를 통해 직접 알림
        guard let appCoordinator = self.appCoordinator,
              let authCoordinator = appCoordinator.childCoordinators.first(where: { $0 is AuthCoordinator }) as? AuthCoordinator else {
            print("❌ Coordinator들을 찾을 수 없음")
            return
        }
        
        authCoordinator.authenticationDidComplete()
    }
    
    private func handleAuthenticationSuccess() {
        print("🎉 인증 성공 - 리포지토리 선택 화면으로 이동")
        
        // AppCoordinator에게 인증 완료 알림
        if let appCoordinator = appCoordinator {
            appCoordinator.authenticationDidComplete()
        }
    }
    
    private func handleAuthenticationFailure(_ error: GitHubAuthError) {
        DispatchQueue.main.async { [weak self] in
            self?.showAuthenticationError(error)
        }
    }
    
    private func showAuthenticationError(_ error: GitHubAuthError) {
        guard let rootViewController = window?.rootViewController else { return }
        
        let alert = UIAlertController(
            title: "로그인 실패",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        rootViewController.present(alert, animated: true)
    }
    

    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

