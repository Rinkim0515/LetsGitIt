//
//  SceneDelegate.swift
//  LetsGitIt
//
//  Created by KimRin on 5/27/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // 로그인 상태에 따라 초기 화면 결정
        let initialViewController: UIViewController
        
        if GitHubAuthManager.shared.isLoggedIn {
            // ✅ Clean Architecture: DI Container를 통해 의존성 주입
            initialViewController = DIContainer.shared.makeMainTabBarController()
        } else {
            initialViewController = LoginViewController()
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        // GitHub 콜백인지 확인
        if url.scheme == "letsgitit" {
            GitHubAuthManager.shared.handleCallback(url: url) { [weak self] result in
                switch result {
                case .success(let token):
                    print("✅ 로그인 성공: \(token)")
                    self?.navigateToMainScreen()
                    
                case .failure(let error):
                    print("❌ 로그인 실패: \(error)")
                    // 에러 처리 (알림 등)
                }
            }
        }
    }
    
    /// 메인 화면으로 이동
    private func navigateToMainScreen() {
        DispatchQueue.main.async {
            // ✅ Clean Architecture: DI Container 사용
            self.window?.rootViewController = DIContainer.shared.makeMainTabBarController()
        }
    }
    
    /// 메인 뷰컨트롤러 생성 (임시)
    private func createMainViewController() -> UIViewController {
        MainTabBarController()
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

