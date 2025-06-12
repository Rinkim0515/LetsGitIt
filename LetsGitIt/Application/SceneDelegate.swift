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
        
        print("📱 URL 콜백 수신: \(url)")
        
        // GitHub OAuth 콜백인지 확인
        if url.scheme == "letsgitit" && url.host == "callback" {
            handleGitHubCallback(url: url)
        }
    }
    private func handleGitHubCallback(url: URL) {
        print("🔐 GitHub 콜백 처리 시작")
        dismissPresentedVC()
        
        // GitHubAuthManager를 통해 토큰 교환
        GitHubAuthManager.shared.handleCallback(url: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    print("✅ 토큰 교환 성공: \(token)")
                    self?.handleAuthenticationSuccess()
                    
                case .failure(let error):
                    print("❌ 토큰 교환 실패: \(error)")
                    self?.handleAuthenticationFailure(error)
                }
            }
        }
    }
    private func dismissPresentedVC() {
        if let presentedVC = window?.rootViewController?.presentedViewController {
            presentedVC.dismiss(animated: true) {
                print("🌐 Safari 화면 닫힘")
            }
        }
    }
    
    private func handleAuthenticationSuccess() {
        print("🎉 인증 성공 - AppCoordinator에 알림")
        
        // ✅ AppCoordinator에게 직접 인증 완료 알림
        appCoordinator?.authenticationDidComplete()
    }
    
    private func handleAuthenticationFailure(_ error: GitHubAuthError) {
        print("💥 인증 실패: \(error.localizedDescription)")
        showAuthenticationError(error)
    }
    
    private func showAuthenticationError(_ error: GitHubAuthError) {
        guard let rootVC = window?.rootViewController else { return }
        
        let alert = UIAlertController(
            title: "로그인 실패",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        rootVC.present(alert, animated: true)
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

