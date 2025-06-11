//
//  RepositorySelectionViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class RepositorySelectionViewController: UIViewController, LoadingCapable {
    weak var coordinator: RepositorySelectionCoordinator?
    // MARK: - UI Components
    // 상단 고정 영역
    private let headerView = UIView()
    private let searchBar = UISearchBar()
    private let greetingLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // 리포지토리 리스트
    private let tableView = UITableView()
    
    // 하단 완료 버튼
    private let completeButton = UIButton(type: .system)
    
    // MARK: - Properties
    private var repositories: [GitHubRepository] = []
    private var filteredRepositories: [GitHubRepository] = []
    private var selectedRepository: GitHubRepository?
    
    private let getCurrentUserUseCase: GetCurrentUserUseCase
    private let getUserRepositoriesUseCase: GetUserRepositoriesUseCase
    
    // MARK: - Initialization
    init(getCurrentUserUseCase: GetCurrentUserUseCase, getUserRepositoriesUseCase: GetUserRepositoriesUseCase) {
        self.getCurrentUserUseCase = getCurrentUserUseCase
        self.getUserRepositoriesUseCase = getUserRepositoriesUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
        setupSearchBar()
        loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .backgroundSecondary
        
        // 헤더 뷰 설정
        headerView.backgroundColor = .backgroundSecondary
        
        // 검색바 설정
        searchBar.placeholder = "Repository 검색"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        
        // 인사말 라벨
        greetingLabel.font = .pretendard(.semiBold, size: 20)
        greetingLabel.textColor = .white
        greetingLabel.numberOfLines = 0
        
        // 설명 라벨
        descriptionLabel.text = "작업을 시작할 Repository를 선택해주세요."
        descriptionLabel.font = .pretendard(.regular, size: 16)
        descriptionLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        descriptionLabel.numberOfLines = 0
        
        // 테이블뷰 설정
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        // 완료 버튼 설정
        completeButton.setTitle("완료", for: .normal)
        completeButton.titleLabel?.font = .pretendard(.semiBold, size: 18)
        completeButton.backgroundColor = .systemBlue
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.layer.cornerRadius = 12
        completeButton.isEnabled = false
        completeButton.alpha = 0.5
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        
        // 뷰 계층 구성
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(completeButton)
        headerView.addSubview(searchBar)
        headerView.addSubview(greetingLabel)
        headerView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        [headerView, searchBar, greetingLabel, descriptionLabel,
         tableView, completeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 헤더 뷰 (상단 고정)
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // 검색바
            searchBar.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            // 인사말 라벨
            greetingLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            greetingLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            greetingLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            // 설명 라벨
            descriptionLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            
            // 테이블뷰
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -20),
            
            // 완료 버튼 (하단 고정)
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 56),
            
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.id)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    // MARK: - Data Loading
    private func loadData() {
        showLoading() // ✅ LoadingCapable 사용 (기존: loadingIndicator.startAnimating())
        
        Task {
            do {
                // 사용자 정보와 리포지토리 목록을 병렬로 가져오기
                async let user = getCurrentUserUseCase.execute()
                async let repos = getUserRepositoriesUseCase.execute()
                
                let (userData, repositoryData) = try await (user, repos)
                
                await MainActor.run {
                    updateUI(with: userData, repositories: repositoryData)
                    hideLoading() // ✅ LoadingCapable 사용 (기존: loadingIndicator.stopAnimating())
                }
            } catch {
                await MainActor.run {
                    showError("데이터를 불러오지 못했습니다: \(error.localizedDescription)")
                    hideLoading() // ✅ LoadingCapable 사용 (기존: loadingIndicator.stopAnimating())
                }
            }
        }
    }
    
    
    private func updateUI(with user: GitHubUser, repositories: [GitHubRepository]) {
        // 인사말 업데이트
        greetingLabel.text = "\"\(user.login)\"님 안녕하세요."
        
        // 리포지토리 목록 업데이트 (최근 업데이트순으로 정렬)
        self.repositories = repositories.sorted { $0.updatedAt > $1.updatedAt }
        self.filteredRepositories = self.repositories
        
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func completeButtonTapped() {
        guard let selectedRepo = selectedRepository else { return }
        
        // ✅ Coordinator에게 Flow 처리 위임
        coordinator?.didSelectRepository(selectedRepo)
    }
    
    private func saveSelectedRepository(_ repository: GitHubRepository) {
        UserDefaults.standard.set(repository.name, forKey: "selected_repository_name")
        UserDefaults.standard.set(repository.owner.login, forKey: "selected_repository_owner")
        print("✅ 선택된 리포지토리 저장: \(repository.fullName)")
    }
    

    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension RepositorySelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.id, for: indexPath) as! RepositoryCell
        let repository = filteredRepositories[indexPath.row]
        let isSelected = selectedRepository?.id == repository.id
        
        cell.configure(with: repository, isSelected: isSelected)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RepositorySelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let repository = filteredRepositories[indexPath.row]
        
        // ✅ 선택된 리포지토리 설정
        selectedRepository = repository
        tableView.reloadData()
        
        // 완료 버튼 활성화
        completeButton.isEnabled = true
        UIView.animate(withDuration: 0.2) {
            self.completeButton.alpha = 1.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

// MARK: - UISearchBarDelegate
extension RepositorySelectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredRepositories = repositories
        } else {
            filteredRepositories = repositories.filter { repository in
                repository.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}
