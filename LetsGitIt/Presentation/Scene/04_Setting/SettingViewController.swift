//
//  SettingViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import UIKit

final class SettingViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let titleView = TitleHeaderView()
    // 상단 코어타임 설정 섹션
    private let coreTimeSettingsView = CoreTimeSettingsView()
    
    // 하단 테이블뷰 섹션
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    // 하단 버튼들
    private let footerView = UIView()
    private let withdrawButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)
    
    // MARK: - Properties
    private let settingsItems: [SettingsItem] = [
        .repositoryDetail,
        .repositoryChange,
        .termsOfService,
        .privacyPolicy,
        .version
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .backgroundSecondary
        titleView.configure(title: "설정")
        
        // 스크롤뷰 설정
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        // 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // 테이블뷰 설정
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false // 스크롤뷰 안에 있으므로
        tableView.showsVerticalScrollIndicator = false
        
        // 하단 버튼들 설정
        setupFooterButtons()
        
        // 뷰 계층 구성
        view.addSubview(scrollView)
        view.addSubview(titleView)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(coreTimeSettingsView)
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(footerView)
    }
    
    
    private func setupFooterButtons() {
        // 회원탈퇴 버튼
        withdrawButton.setTitle("회원탈퇴", for: .normal)
        withdrawButton.titleLabel?.font = .pretendard(.regular, size: 16)
        withdrawButton.setTitleColor(.systemGray, for: .normal)
        withdrawButton.backgroundColor = .clear
        
        // 로그아웃 버튼
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.titleLabel?.font = .pretendard(.semiBold, size: 16)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .systemBlue
        logoutButton.layer.cornerRadius = 12
        
        // Footer View에 추가
        footerView.addSubview(withdrawButton)
        footerView.addSubview(logoutButton)
    }
    
    private func setupConstraints() {
        // Auto Layout 비활성화
        [scrollView, stackView, withdrawButton, logoutButton, titleView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 15),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            // 스크롤뷰
            scrollView.topAnchor.constraint(equalTo: titleView.bottomAnchor,constant: 15),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 스택뷰
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            
            
            // Footer View 높이
            footerView.heightAnchor.constraint(equalToConstant: 120),
            
            // 회원탈퇴 버튼
            withdrawButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            withdrawButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -34),
            withdrawButton.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.4, constant: -15),
            withdrawButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 로그아웃 버튼
            logoutButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            logoutButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -34),
            logoutButton.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.4, constant: -15),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 테이블뷰 높이를 뷰가 로드된 후에 설정
        DispatchQueue.main.async { [weak self] in
            self?.updateTableViewHeight()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.id)
    }
    
    private func setupActions() {
        withdrawButton.addAction(UIAction { [weak self] _ in
            self?.withdrawButtonTapped()
        }, for: .touchUpInside)
        
        logoutButton.addAction(UIAction { [weak self] _ in
            self?.logoutButtonTapped()
        }, for: .touchUpInside)
        
        
    }
    
    // MARK: - Helper Methods
    private func calculateTableViewHeight() -> CGFloat {
        // 단일 섹션이므로 총 아이템 개수만 계산
        let numberOfRows = settingsItems.count
        return CGFloat(numberOfRows) * 56 // 각 셀 높이 56pt
    }
    
    private func updateTableViewHeight() {
        let height = calculateTableViewHeight()
        tableView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.isActive = false
            }
        }
        tableView.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.layoutIfNeeded()
    }
    

}




// MARK: - UITableViewDataSource & UITableViewDelegate
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // 단일 섹션
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.id, for: indexPath) as! SettingsTableViewCell
        
        let item = settingsItems[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = settingsItems[indexPath.row]
        handleSettingsItemTap(item)
    }
}

// MARK: - Settings Item Handler
extension SettingViewController {
    private func handleSettingsItemTap(_ item: SettingsItem) {
        switch item {
        case .repositoryDetail:
            // TODO: Repository 상세 화면으로 이동
            print("Repository 상세")
            
        case .repositoryChange:
            // TODO: Repository 변경 화면으로 이동
            print("Repository 변경")
            
        case .termsOfService:
            // TODO: 이용약관 화면으로 이동
            print("서비스 이용약관")
            
        case .privacyPolicy:
            // TODO: 개인정보처리방침 화면으로 이동
            print("개인정보처리방침")
            
        case .version:
            // 버전 정보는 클릭 불가 (정보 표시용)
            break
        }
    }
}


//MARK: - Alert Logic
extension SettingViewController {
    
    private func logoutButtonTapped() {
        let alert = CustomAlert.builder()
            .title("로그아웃")
            .message("로그아웃 하시겠어요?")
            .dualAction(secondary: "취소", primary: "로그아웃")
            .primaryAction {
                GitHubAuthManager.shared.logout()
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = LoginViewController()
                    }
                }
            }
            .secondaryAction { [weak self] in
                print("로그아웃 취소")
                self?.dismiss(animated: true)
            }
            .build()
        alert.show(on: self)
    }
    
    private func withdrawButtonTapped() {
        let alert = CustomAlert.builder()
            .title("회원탈퇴")
            .message("로그아웃 하시겠어요?")
            .dualAction(secondary: "취소", primary: "로그아웃")
            .primaryAction {
            }
            .secondaryAction {
            }
            .build()
        alert.show(on: self)
    }
    
    private func turnOffCoreTimeToggleTapped() {
        let alert = CustomAlert.builder()
            .title("로그아웃")
            .message("로그아웃 하시겠어요?")
            .dualAction(secondary: "취소", primary: "로그아웃")
            .primaryAction {

            }
            .secondaryAction {

            }
            .build()
        alert.show(on: self)
    }
    
}
