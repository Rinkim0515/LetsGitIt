//
//  AllRepositoryViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/9/25.
//

import UIKit

final class AllRepositoryViewController: UIViewController {
    
    // MARK: - UI Components
    private let titleView = TitleHeaderView()
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Properties
    private var repositories: [GitHubRepository] = []
    private var selectedRepositoryName: String? {
        return UserDefaults.standard.string(forKey: "selected_repository_name")
    }
    private var selectedRepositoryOwner: String? {
        return UserDefaults.standard.string(forKey: "selected_repository_owner")
    }
    
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
        setupRefreshControl()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Setup
    private func setupUI() {
        titleView.configure(title: "레포지토리")
        view.backgroundColor = .backgroundSecondary
        // 로딩 인디케이터
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        
        // 테이블뷰
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(titleView)
    }
    
    private func setupConstraints() {
        [titleView, tableView, loadingIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor,constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AllRepositoryCell.self, forCellReuseIdentifier: AllRepositoryCell.id)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Data Loading
    private func loadData() {
        if !refreshControl.isRefreshing {
            loadingIndicator.startAnimating()
        }
        
        Task {
            do {
                let repositories = try await getUserRepositoriesUseCase.execute()
                
                await MainActor.run {
                    updateUI(with: repositories)
                    loadingIndicator.stopAnimating()
                    refreshControl.endRefreshing()
                }
            } catch {
                await MainActor.run {
                    showError("데이터를 불러오지 못했습니다: \(error.localizedDescription)")
                    loadingIndicator.stopAnimating()
                    refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func updateUI(with repositories: [GitHubRepository]) {
        // 최근 업데이트순으로 정렬
        self.repositories = repositories.sorted { $0.updatedAt > $1.updatedAt }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func handleRefresh() {
        loadData()
    }
    
    // MARK: - Helper Methods
    private func isSelectedRepository(_ repository: GitHubRepository) -> Bool {
        guard let selectedName = selectedRepositoryName,
              let selectedOwner = selectedRepositoryOwner else {
            return false
        }
        return repository.name == selectedName && repository.owner.login == selectedOwner
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AllRepositoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllRepositoryCell.id, for: indexPath) as! AllRepositoryCell
        let repository = repositories[indexPath.row]
        let isSelected = isSelectedRepository(repository)
        
        cell.configure(with: repository, isSelectedRepository: isSelected)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AllRepositoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let repository = repositories[indexPath.row]
        print("📍 레포지토리 선택됨: \(repository.fullName)")
        
        // 레포지토리 상세 화면으로 이동
        let repositoryDetailVC = RepositoryDetailViewController(repository: repository)
        repositoryDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(repositoryDetailVC, animated: true)
    }
}
