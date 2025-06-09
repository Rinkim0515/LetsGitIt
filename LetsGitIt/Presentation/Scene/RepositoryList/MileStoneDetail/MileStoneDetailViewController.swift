//
//  MilestoneDetailViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import UIKit

final class MilestoneDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let mockData: MockMilestoneDetail
    
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
    private var issues: [IssueItem] = []
    
    // MARK: - Initialization
    init(mockData: MockMilestoneDetail) {
        self.mockData = mockData
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
        
        stackView.addArrangedSubview(createSpacerView(height: 16))
        stackView.addArrangedSubview(milestoneInfoView)
        stackView.addArrangedSubview(createSpacerView(height: 8))
        stackView.addArrangedSubview(issueHeaderView)
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(createSpacerView(height: 32))
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
        title = mockData.milestone.title
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
        
        // Mock 데이터의 상태에 따라 설정
        let isOpen = mockData.milestone.ddayType == .upcoming // Open 상태로 가정
        
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
        // 마일스톤 정보 설정
        milestoneInfoView.configure(with: mockData.milestone)
        
        // 이슈 목록 설정
        issues = mockData.issues
        tableView.reloadData()
        updateTableViewHeight()
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleRefresh() {
        // Mock 새로고침 시뮬레이션
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
            print("🔄 새로고침 완료")
        }
    }
    
    // MARK: - Helper Methods
    private func createSpacerView(height: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        return spacer
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
extension MilestoneDetailViewController: UITableViewDataSource {
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
extension MilestoneDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let issue = issues[indexPath.row]
        print("📍 이슈 선택됨: #\(issue.number) \(issue.title)")
        
        // TODO: 나중에 IssueDetailViewController로 이동
        // let issueDetailVC = IssueDetailViewController(issue: issue)
        // navigationController?.pushViewController(issueDetailVC, animated: true)
    }
}

// MARK: - Mock Data Model
struct MockMilestoneDetail {
    let milestone: MilestoneItem
    let issues: [IssueItem]
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
            IssueItem(id: "1", title: "로그인 기능 구현", number: 45, author: "developer1"),
            IssueItem(id: "2", title: "UI 개선 작업", number: 44, author: "designer1"),
            IssueItem(id: "3", title: "API 연동 완료", number: 43, author: "backend-dev"),
            IssueItem(id: "4", title: "테스트 코드 작성", number: 42, author: "tester1"),
            IssueItem(id: "5", title: "버그 수정 및 최적화", number: 41, author: "developer2"),
            IssueItem(id: "6", title: "문서 업데이트", number: 40, author: "technical-writer"),
            IssueItem(id: "7", title: "배포 스크립트 개선", number: 39, author: "devops-team"),
            IssueItem(id: "8", title: "성능 테스트", number: 38, author: "qa-team")
        ]
    )
}
