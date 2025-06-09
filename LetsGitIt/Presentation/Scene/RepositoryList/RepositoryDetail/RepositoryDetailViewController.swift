//
//  RepositoryDetailViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/9/25.
//

import UIKit

final class RepositoryDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let repository: GitHubRepository
    
    // MARK: - UI Components
    private let segmentedControl = UISegmentedControl(items: ["이슈", "마일스톤"])
    private let containerView = UIView()
    
    // Custom Views
    private let issueFilteringView = IssueFilteringView()
    private let milestoneListView = MilestoneListView()
    
    // MARK: - Data
    private var milestones: [MilestoneData] = []
    private var milestoneItems: [MilestoneItem] = []
    
    // MARK: - Initialization
    init(repository: GitHubRepository) {
        self.repository = repository
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
        loadMockData()
        updateContainerView()
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
            let issueDetailVC = IssueDetailViewController(issue: issue)
            issueDetailVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(issueDetailVC, animated: true)
        }
        
        // 마일스톤 선택 콜백
        milestoneListView.onMilestoneSelected = { [weak self] milestone in
            print("📍 마일스톤 선택됨: \(milestone.title)")
            // TODO: 마일스톤 상세 화면으로 이동
        }
    }
    
    // MARK: - Data Loading
    private func loadMockData() {
        // 이슈 데이터 (기존 MilestoneData)
        milestones = MilestoneData.mockData
        
        // 마일스톤 카드 데이터
        milestoneItems = [
            MilestoneItem(
                id: "1",
                title: "Sprint 1 개발",
                description: "로그인, 회원가입, 프로필 기능 개발을 포함한 첫 번째 스프린트입니다.",
                tag: "Development",
                tagColor: .systemBlue,
                dday: "D-7",
                ddayType: .upcoming,
                progress: 0.75
            ),
            MilestoneItem(
                id: "2",
                title: "UI/UX 개선",
                description: "사용자 경험 향상을 위한 인터페이스 디자인 및 사용성 개선 작업입니다.",
                tag: "Design",
                tagColor: .systemPink,
                dday: "D-14",
                ddayType: .upcoming,
                progress: 0.45
            ),
            MilestoneItem(
                id: "3",
                title: "Beta 테스트",
                description: "실제 사용자를 대상으로 한 베타 테스트 및 피드백 수집 단계입니다.",
                tag: "Testing",
                tagColor: .systemOrange,
                dday: "D+3",
                ddayType: .overdue,
                progress: 0.90
            ),
            MilestoneItem(
                id: "4",
                title: "출시 준비",
                description: "앱 스토어 등록, 마케팅 자료 준비, 최종 배포 준비 작업입니다.",
                tag: "Release",
                tagColor: .systemGreen,
                dday: "D-21",
                ddayType: .upcoming,
                progress: 0.20
            ),
            MilestoneItem(
                id: "5",
                title: "성능 최적화",
                description: "앱 성능 개선 및 메모리 사용량 최적화 작업을 진행합니다.",
                tag: "Performance",
                tagColor: .systemPurple,
                dday: "D-30",
                ddayType: .upcoming,
                progress: 0.10
            )
        ]
        
        // Views에 데이터 전달
        issueFilteringView.updateMilestones(milestones)
        milestoneListView.updateMilestones(milestoneItems)
        
        // FloatingSegmentedControl 위치 조정 (SafeArea 고려)
        issueFilteringView.updateFloatingSegmentPosition(bottomConstant: -20)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
