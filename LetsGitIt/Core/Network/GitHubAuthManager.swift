//
//  GitHubAuthManager.swift
//  LetsGitIt
//
//  Created by KimRin on 5/27/25.
//
// Network/GitHubAuthManager.swift
import UIKit
import SafariServices

// MARK: - Auth Error Types
enum GitHubAuthError: Error {
    case invalidURL
    case missingAuthCode
    case tokenExchangeFailed
    case networkError(Error)
    case invalidResponse
}

// MARK: - Auth Models
struct GitHubTokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
}

class GitHubAuthManager {
    static let shared = GitHubAuthManager()
    
    // MARK: - Configuration
    private struct Config {
        static let clientID = GitHubConfig.clientID
        static let clientSecret = GitHubConfig.clientSecret
        static let redirectURI = "letsgitit://callback"
        static let scope = "repo user"
        static let authURL = "https://github.com/login/oauth/authorize"
        static let tokenURL = "https://github.com/login/oauth/access_token"
    }
    
    // MARK: - Storage Keys
    private struct StorageKeys {
        static let accessToken = "github_access_token"
    }
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// OAuth 로그인 플로우 시작
    func startOAuthFlow(from viewController: UIViewController) {
        guard let authURL = buildAuthURL() else {
            print("❌ Invalid auth URL")
            return
        }
        
        let safariVC = SFSafariViewController(url: authURL)
        viewController.present(safariVC, animated: true)
    }
    
    /// 콜백 URL 처리
    func handleCallback(url: URL, completion: @escaping (Result<String, GitHubAuthError>) -> Void) {
        print("📱 Callback received: \(url)")
        
        guard let authCode = extractAuthCode(from: url) else {
            completion(.failure(.missingAuthCode))
            return
        }
        
        print("🔐 Auth code: \(authCode)")
        exchangeCodeForToken(code: authCode, completion: completion)
    }
    
    /// 현재 로그인 상태 확인
    var isLoggedIn: Bool {
        return UserDefaults.standard.string(forKey: StorageKeys.accessToken) != nil
    }
    
    /// 로그아웃
    func logout() {
        UserDefaults.standard.removeObject(forKey: StorageKeys.accessToken)
        print("📤 로그아웃 완료")
    }
    
    /// 저장된 토큰 가져오기
    var accessToken: String? {
        return UserDefaults.standard.string(forKey: StorageKeys.accessToken)
    }
    
    // MARK: - Private Methods
    
    /// GitHub OAuth URL 생성
    private func buildAuthURL() -> URL? {
        var components = URLComponents(string: Config.authURL)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: Config.clientID),
            URLQueryItem(name: "redirect_uri", value: Config.redirectURI),
            URLQueryItem(name: "scope", value: Config.scope),
            URLQueryItem(name: "state", value: UUID().uuidString)
        ]
        return components?.url
    }
    
    /// URL에서 인증 코드 추출
    private func extractAuthCode(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        
        return queryItems.first(where: { $0.name == "code" })?.value
    }
    
    /// 인증 코드를 Access Token으로 교환
    private func exchangeCodeForToken(code: String, completion: @escaping (Result<String, GitHubAuthError>) -> Void) {
        guard let url = URL(string: Config.tokenURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = [
            "client_id": Config.clientID,
            "client_secret": Config.clientSecret,
            "code": code
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(.networkError(error)))
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.networkError(error)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                self?.parseTokenResponse(data: data, completion: completion)
            }
        }.resume()
    }
    
    /// 토큰 응답 파싱 및 저장
    private func parseTokenResponse(data: Data, completion: @escaping (Result<String, GitHubAuthError>) -> Void) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let accessToken = json["access_token"] as? String {
                
                // 토큰 저장
                UserDefaults.standard.set(accessToken, forKey: StorageKeys.accessToken)
                print("✅ Access Token 저장 완료")
                
                completion(.success(accessToken))
            } else {
                print("❌ Access Token을 찾을 수 없습니다")
                print("응답: \(String(data: data, encoding: .utf8) ?? "없음")")
                completion(.failure(.tokenExchangeFailed))
            }
        } catch {
            completion(.failure(.networkError(error)))
        }
    }
}
