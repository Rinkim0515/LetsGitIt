//
//  AllRepositoryViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/9/25.
//

import UIKit

final class RepoListVC: UIViewController, LoadingCapable, ErrorHandlingCapable {
    weak var coordinator: RepositoryListCoordinator?
    // MARK: - UI Components
    private let titleView = TitleHeaderView()
    private let tableView = UITableView()
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

        
        // 테이블뷰
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)

        view.addSubview(titleView)
    }
    
    private func setupConstraints() {
        [titleView, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 15),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor,constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RepoListCell.self, forCellReuseIdentifier: RepoListCell.id)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // 기존: if !refreshControl.isRefreshing { loadingIndicator.startAnimating() }
        // 개선: 새로고침 중이 아닐 때만 로딩 표시
        if !refreshControl.isRefreshing {
            showLoading() // ✅ LoadingCapable 사용
        }
        
        Task {
            do {
                let repositories = try await getUserRepositoriesUseCase.execute()
                
                await MainActor.run {
                    updateUI(with: repositories)
                    hideLoading() // ✅ LoadingCapable 사용
                    refreshControl.endRefreshing()
                }
            } catch {
                await MainActor.run {
                    showDataLoadingErrorAlert {
                        print("에러 알럿 확인 버튼 클릭됨")
                    }
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
    

}

// MARK: - UITableViewDataSource
extension RepoListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoListCell.id, for: indexPath) as! RepoListCell
        let repository = repositories[indexPath.row]
        let isSelected = isSelectedRepository(repository)
        
        cell.configure(with: repository, isSelectedRepository: isSelected)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RepoListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let repository = repositories[indexPath.row]
        print("📍 리포지토리 선택됨: \(repository.fullName)")
        
        // ✅ Coordinator를 통해 상세 화면으로 이동
        coordinator?.showRepositoryDetail(repository)
    }
}
