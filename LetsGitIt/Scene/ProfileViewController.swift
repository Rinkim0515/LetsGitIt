//
//  ProfileViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 5/27/25.
//

import Foundation
// ViewControllers/ProfileViewController.swift
import UIKit

class ProfileViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI 요소들
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let bioLabel = UILabel()
    private let statsStackView = UIStackView()
    private let reposCountLabel = UILabel()
    private let followersCountLabel = UILabel()
    private let followingCountLabel = UILabel()
    private let logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserProfile()
    }
    
    private func setupUI() {
        title = "프로필"
        view.backgroundColor = .systemBackground
        
        // 스크롤뷰 설정
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 아바타 이미지뷰
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 60
        avatarImageView.backgroundColor = .systemGray5
        
        // 이름 라벨
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .center
        
        // 사용자명 라벨
        usernameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        usernameLabel.textColor = .systemGray
        usernameLabel.textAlignment = .center
        
        // 바이오 라벨
        bioLabel.font = .systemFont(ofSize: 16)
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .center
        
        // 통계 스택뷰
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 20
        
        // 통계 라벨들
        [reposCountLabel, followersCountLabel, followingCountLabel].forEach { label in
            label.textAlignment = .center
            label.numberOfLines = 2
            statsStackView.addArrangedSubview(label)
        }
        
        // 로그아웃 버튼
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        logoutButton.backgroundColor = .systemRed
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 8
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        // Auto Layout 설정
        [avatarImageView, nameLabel, usernameLabel, bioLabel, statsStackView, logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 스크롤뷰
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 콘텐트뷰
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 아바타
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // 이름
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 사용자명
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 바이오
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 15),
            bioLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bioLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 통계
            statsStackView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 30),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statsStackView.heightAnchor.constraint(equalToConstant: 60),
            
            // 로그아웃 버튼
            logoutButton.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 40),
            logoutButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func loadUserProfile() {
        GitHubAPIManager.shared.getCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.updateUI(with: user)
            case .failure(let error):
                print("❌ 사용자 정보 로딩 실패: \(error)")
                // TODO: 에러 알림 표시
            }
        }
    }
    
    private func updateUI(with user: GitHubUser) {
        nameLabel.text = user.name ?? "이름 없음"
        usernameLabel.text = "@\(user.login)"
        bioLabel.text = user.bio ?? "소개가 없습니다."
        
        // 통계 정보
        reposCountLabel.text = "\(user.publicRepos)\n레포지토리"
        followersCountLabel.text = "\(user.followers)\n팔로워"
        followingCountLabel.text = "\(user.following)\n팔로잉"
        
        // 아바타 이미지 로드
        loadAvatarImage(from: user.avatarUrl)
    }
    
    private func loadAvatarImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }.resume()
    }
    
    @objc private func logoutTapped() {
        GitHubAuthManager.shared.logout()
        
        // 로그인 화면으로 이동
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = LoginViewController()
        }
    }
}
