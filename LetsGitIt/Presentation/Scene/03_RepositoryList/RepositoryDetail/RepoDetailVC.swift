//
//  RepositoryDetailViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/9/25.
//

import UIKit

final class RepoDetailVC: UIViewController {
    weak var coordinator: RepositoryDetailCoordinator?
    // MARK: - Properties
    private let repository: GitHubRepository
    
    
    private let getMilestonesUseCase: GetRepositoryMilestonesUseCase
    private let getIssuesUseCase: GetRepositoryIssuesUseCase
    
    // MARK: - UI Components
    private let segmentedControl = UISegmentedControl(items: ["이슈", "마일스톤"])
    private let containerView = UIView()
    
    // Custom Views
    private let issueFilteringView = IssueFilteringView()
    private let milestoneListView = MilestoneListView()
    
    // MARK: - Data
    private var milestones: [GitHubMilestone] = []
    private var milestoneItems: [MilestoneItem] = []
    private var issues: [GitHubIssue] = []
    // MARK: - Initialization
    init(
        repository: GitHubRepository,
        getMilestonesUseCase: GetRepositoryMilestonesUseCase,
        getIssuesUseCase: GetRepositoryIssuesUseCase
    ) {
        self.repository = repository
        self.getMilestonesUseCase = getMilestonesUseCase
        self.getIssuesUseCase = getIssuesUseCase
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
        setupCallbacks()
        loadData()
        updateContainerView()
    }
    
    
    private func loadData() {
        Task {
            do {
                async let milestonesTask = getMilestonesUseCase.execute(
                    owner: repository.owner.login,
                    repo: repository.name
                )
                // ✅ 모든 이슈 가져오기 (state 파라미터 없음)
                async let issuesTask = getIssuesUseCase.executeForAllIssues(
                    owner: repository.owner.login,
                    repo: repository.name
                )
                
                let (milestonesData, issuesData) = try await (milestonesTask, issuesTask)
                
                await MainActor.run {
                    self.milestones = milestonesData
                    self.issues = issuesData
                    self.updateViews()
                    print("✅ 데이터 로딩 완료: 마일스톤 \(milestonesData.count)개, 이슈 \(issuesData.count)개 (Open+Closed)")
                }
            } catch {
                await MainActor.run {
                    self.showError("데이터 로딩 실패: \(error.localizedDescription)")
                    print("❌ 데이터 로딩 실패: \(error)")
                }
            }
        }
    }
    
    private func updateViews() {
        issueFilteringView.configure(milestones: milestones, issues: issues)
        milestoneListView.updateMilestones(milestones)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .backgroundSecondary
        title = repository.name
        
        // 네비게이션 설정
        setupNavigationBar()
        
        // 세그먼트 컨트롤 설정
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor(named: "CardBackground") ?? .systemGray6
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        // 컨테이너 뷰
        containerView.backgroundColor = .clear
        
        // 뷰 계층 구성
        view.addSubview(segmentedControl)
        view.addSubview(containerView)
        containerView.addSubview(issueFilteringView)
        containerView.addSubview(milestoneListView)
    }
    
    private func setupNavigationBar() {
        
        
        // 뒤로가기 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    private func setupConstraints() {
        [segmentedControl, containerView, issueFilteringView, milestoneListView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 세그먼트 컨트롤
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            // 컨테이너 뷰
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 이슈 필터링 뷰
            issueFilteringView.topAnchor.constraint(equalTo: containerView.topAnchor),
            issueFilteringView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            issueFilteringView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            issueFilteringView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // 마일스톤 리스트 뷰
            milestoneListView.topAnchor.constraint(equalTo: containerView.topAnchor),
            milestoneListView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            milestoneListView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            milestoneListView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupCallbacks() {
        // 이슈 선택 콜백
        issueFilteringView.onIssueSelected = { [weak self] issue in
            // ✅ coordinator를 통한 이슈 상세 이동
            self?.coordinator?.showIssueDetail(issue)
        }
        
        // 마일스톤 선택 콜백
        milestoneListView.onMilestoneSelected = { [weak self] milestone in
            print("📍 마일스톤 선택됨: \(milestone.title)")
            // ✅ coordinator를 통한 마일스톤 상세 이동
            self?.coordinator?.showMilestoneDetail(milestone)
        }
    }
    
    // MARK: - Data Loading

    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        coordinator?.navigateBack()
    }
    
    @objc private func segmentChanged() {
        updateContainerView()
    }
    
    private func updateContainerView() {
        let isIssueSelected = segmentedControl.selectedSegmentIndex == 0
        
        UIView.animate(withDuration: 0.3) {
            self.issueFilteringView.alpha = isIssueSelected ? 1.0 : 0.0
            self.milestoneListView.alpha = isIssueSelected ? 0.0 : 1.0
        } completion: { _ in
            self.issueFilteringView.isHidden = !isIssueSelected
            self.milestoneListView.isHidden = isIssueSelected
        }
    }
}
