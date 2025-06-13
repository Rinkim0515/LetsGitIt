//
//  MilestoneDetailViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import UIKit

final class MilestoneDetailVC: UIViewController, LoadingCapable, ErrorHandlingCapable {
    var coordinator: MilestoneDetailCoordinator?
    
    private let getMilestoneDetailUseCase: GetMilestoneDetailUseCase
    private let repository: GitHubRepository
    private let milestone: GitHubMilestone
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    // 마일스톤 정보 섹션
    private let milestoneInfoView = MilestoneInfoView()
    
    // 이슈 섹션
    private let issueHeaderView = TitleHeaderView()
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Data
    private var milestoneDetail: MilestoneDetail?
    private var issues: [GitHubIssue] = []
    
    // MARK: - Initialization
    init(
        milestone: GitHubMilestone,
        repository: GitHubRepository,
        getMilestoneDetailUseCase: GetMilestoneDetailUseCase
    ) {
        self.milestone = milestone
        self.repository = repository
        self.getMilestoneDetailUseCase = getMilestoneDetailUseCase
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
        setupNavigationBar()
        setupTableView()
        setupRefreshControl()
        loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .backgroundSecondary
        
        // 스크롤뷰 설정
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        // 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // 이슈 헤더 설정
        issueHeaderView.configure(title: "이슈 목록", showMoreButton: false)
        
        // 테이블뷰 설정
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        // 뷰 계층 구성
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(milestoneInfoView)
        stackView.addArrangedSubview(issueHeaderView)
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(UIView.createSpacerView(height: 10))
    }
    
    private func setupConstraints() {
        [scrollView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 스크롤뷰
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 스택뷰
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 테이블뷰 높이 (동적 계산)
            tableView.heightAnchor.constraint(equalToConstant: calculateTableViewHeight())
        ])
    }
    
    private func setupNavigationBar() {
        // 타이틀 설정
        title = milestone.title
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // 뒤로가기 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        // 상태 버튼 (우측)
        setupStatusButton()
    }
    
    private func setupStatusButton() {
        let statusButton = UIButton(type: .system)
        statusButton.titleLabel?.font = .pretendard(.semiBold, size: 14)
        statusButton.layer.cornerRadius = 16
        statusButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        // 마일스톤 상태에 따라 설정
        let isOpen = milestone.state == .open
        
        if isOpen {
            statusButton.setTitle("Open", for: .normal)
            statusButton.backgroundColor = .systemBlue
            statusButton.setTitleColor(.white, for: .normal)
        } else {
            statusButton.setTitle("Closed", for: .normal)
            statusButton.backgroundColor = .systemGray
            statusButton.setTitleColor(.white, for: .normal)
        }
        
        // 제약조건 설정
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        statusButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        statusButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: statusButton)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(IssueStatusTableViewCell.self, forCellReuseIdentifier: IssueStatusTableViewCell.id)
        tableView.isScrollEnabled = false // 스크롤뷰 안에 있으므로
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    // MARK: - Data Loading
    private func loadData() {
        print("🔄 마일스톤 상세 데이터 로딩 시작: \(milestone.title)")
        showLoading()
        
        Task {
            do {
                let milestoneDetail = try await getMilestoneDetailUseCase.execute(
                    owner: repository.owner.login,
                    repo: repository.name,
                    milestone: milestone
                )
                
                await MainActor.run {
                    self.milestoneDetail = milestoneDetail
                    self.updateUI(with: milestoneDetail)
                    self.hideLoading()
                    print("✅ 마일스톤 상세 로딩 완료: 이슈 \(milestoneDetail.issues.count)개")
                }
            } catch {
                await MainActor.run {
                    self.hideLoading()
                    self.showDataLoadingErrorAlert {
                        print("마일스톤 상세 로딩 실패: \(error)")
                    }
                }
            }
        }
    }
    private func updateUI(with milestoneDetail: MilestoneDetail) {
        // 마일스톤 정보 설정 (기존 MilestoneItem 대신 GitHubMilestone 사용)
        let milestoneItem = MilestoneItem(
            id: String(milestoneDetail.milestone.id),
            title: milestoneDetail.milestone.title,
            description: milestoneDetail.milestone.description ?? "설명이 없습니다.",
            tag: "Milestone",
            tagColor: .systemBlue,
            dday: milestoneDetail.milestone.ddayText,
            ddayType: milestoneDetail.milestone.ddayType,
            progress: milestoneDetail.milestone.progress
        )
        
        milestoneInfoView.configure(with: milestoneItem)
        
        // 이슈 목록 설정
        issues = milestoneDetail.issues
        tableView.reloadData()
        updateTableViewHeight()
        
        // 헤더 업데이트
        issueHeaderView.configure(title: "이슈 목록 (\(issues.count)개)", showMoreButton: false)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        coordinator?.navigateBack()
    }
    
    @objc private func handleRefresh() {
        
        coordinator?.refreshMilestone()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    
    private func calculateTableViewHeight() -> CGFloat {
        let itemCount = issues.count
        let itemHeight: CGFloat = 64
        return CGFloat(itemCount) * itemHeight
    }
    
    private func updateTableViewHeight() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let newHeight = self.calculateTableViewHeight()
            
            self.tableView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = newHeight
                }
            }
            
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITableViewDataSource
extension MilestoneDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IssueStatusTableViewCell.id, for: indexPath) as! IssueStatusTableViewCell
        let issue = issues[indexPath.row]
        
        cell.configure(with: issue)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MilestoneDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let issue = issues[indexPath.row]
        coordinator?.showIssueDetail(issue)
    }
}

// MARK: - Mock Data Model
struct MockMilestoneDetail {
    let milestone: MilestoneItem
    let issues: [GitHubIssue]
}

// MARK: - Mock Data
extension MockMilestoneDetail {
    static let sample = MockMilestoneDetail(
        milestone: MilestoneItem(
            id: "1",
            title: "milestone명 v1.0",
            description: "첫 번째 메이저 릴리즈를 위한 마일스톤입니다. 핵심 기능들과 UI/UX 개선 작업이 포함되어 있습니다.",
            tag: "Release",
            tagColor: .systemBlue,
            dday: "D-7",
            ddayType: .upcoming,
            progress: 0.6
        ),
        issues: [

        ]
    )
}
