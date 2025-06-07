//
//  MilestoneViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//


import UIKit

final class MilestoneViewController: UIViewController {
    
    // MARK: - Properties
    private let repositoryName: String
    
    // MARK: - UI Components
    // 상단: 마일스톤 이름들
    private let milestoneNamesCollectionView: UICollectionView
    private let milestoneNamesFlowLayout = UICollectionViewFlowLayout()
    
    // 중간: 선택된 마일스톤의 이슈들
    private let issueListCollectionView: UICollectionView
    private let issueListFlowLayout = UICollectionViewFlowLayout()
    
    // 섹션 헤더
    private let sectionHeaderView = SectionHeaderView()
    
    // 하단: 플로팅 버튼
    private let floatingFilterView = FloatingFilterView()
    
    // MARK: - Data
    private var milestones: [MilestoneData] = []
    private var selectedMilestoneIndex: Int = 0
    private var currentFilter: IssueFilter = .all
    
    private var filteredIssues: [IssueItem] {
        guard selectedMilestoneIndex < milestones.count else { return [] }
        let selectedMilestone = milestones[selectedMilestoneIndex]
        
        switch currentFilter {
        case .all:
            return selectedMilestone.issues
        case .open:
            return selectedMilestone.issues.filter { $0.isOpen }
        case .closed:
            return selectedMilestone.issues.filter { !$0.isOpen }
        }
    }
    
    // MARK: - Initialization
    init(repositoryName: String) {
        self.repositoryName = repositoryName
        self.milestoneNamesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: milestoneNamesFlowLayout)
        self.issueListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: issueListFlowLayout)
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
        setupCollectionViews()
        setupFloatingButton()
        loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .backgroundSecondary
        
        // 섹션 헤더 설정
        updateSectionHeader()
        
        // 뷰 계층 구성
        view.addSubview(milestoneNamesCollectionView)
        view.addSubview(sectionHeaderView)
        view.addSubview(issueListCollectionView)
        view.addSubview(floatingFilterView)
    }
    
    private func setupConstraints() {
        [milestoneNamesCollectionView, sectionHeaderView, issueListCollectionView, floatingFilterView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 상단: 마일스톤 이름들
            milestoneNamesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            milestoneNamesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            milestoneNamesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            milestoneNamesCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            // 섹션 헤더
            sectionHeaderView.topAnchor.constraint(equalTo: milestoneNamesCollectionView.bottomAnchor, constant: 16),
            sectionHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sectionHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // 중간: 이슈 리스트
            issueListCollectionView.topAnchor.constraint(equalTo: sectionHeaderView.bottomAnchor, constant: 8),
            issueListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            issueListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            issueListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ✅ 하단: 플로팅 버튼 (중앙 + 크게)
            floatingFilterView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingFilterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingFilterView.widthAnchor.constraint(equalToConstant: 180),  // 120 → 180
            floatingFilterView.heightAnchor.constraint(equalToConstant: 50)   // 40 → 50
        ])
    }
    
    private func setupNavigationBar() {
        title = repositoryName
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // 뒤로가기 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    private func setupCollectionViews() {
        // 상단: 마일스톤 이름들 CollectionView
        milestoneNamesFlowLayout.scrollDirection = .horizontal
        milestoneNamesFlowLayout.minimumLineSpacing = 12
        milestoneNamesFlowLayout.minimumInteritemSpacing = 0
        
        milestoneNamesCollectionView.backgroundColor = .clear
        milestoneNamesCollectionView.showsHorizontalScrollIndicator = false
        milestoneNamesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        milestoneNamesCollectionView.delegate = self
        milestoneNamesCollectionView.dataSource = self
        milestoneNamesCollectionView.tag = 1
        
        // 중간: 이슈 리스트 CollectionView
        issueListFlowLayout.scrollDirection = .vertical
        issueListFlowLayout.minimumLineSpacing = 12
        issueListFlowLayout.minimumInteritemSpacing = 0
        
        issueListCollectionView.backgroundColor = .clear
        issueListCollectionView.showsVerticalScrollIndicator = false
        issueListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        issueListCollectionView.delegate = self
        issueListCollectionView.dataSource = self
        issueListCollectionView.tag = 2
        
        // 셀 등록
        milestoneNamesCollectionView.register(MilestoneNameCell.self, forCellWithReuseIdentifier: MilestoneNameCell.identifier)
        issueListCollectionView.register(IssueCardCell.self, forCellWithReuseIdentifier: IssueCardCell.identifier)
    }
    
    private func setupFloatingButton() {
        floatingFilterView.onFilterChanged = { [weak self] filter in
            self?.currentFilter = filter
            self?.issueListCollectionView.reloadData()
            self?.updateSectionHeader()
        }
    }
    
    // MARK: - Data Loading
    private func loadData() {
        milestones = MilestoneData.mockData
        selectedMilestoneIndex = 0
        
        milestoneNamesCollectionView.reloadData()
        issueListCollectionView.reloadData()
        updateSectionHeader()
    }
    
    private func updateSectionHeader() {
        guard selectedMilestoneIndex < milestones.count else { return }
        let selectedMilestone = milestones[selectedMilestoneIndex]
        let filteredCount = filteredIssues.count
        
        sectionHeaderView.configure(
            title: "\(selectedMilestone.name)의 이슈들 (\(filteredCount)개)",
            showMoreButton: false
        )
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension MilestoneViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 { // 마일스톤 이름들
            return milestones.count
        } else { // 이슈 리스트
            return filteredIssues.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 { // 마일스톤 이름들
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MilestoneNameCell.identifier, for: indexPath) as! MilestoneNameCell
            let milestone = milestones[indexPath.item]
            let isSelected = indexPath.item == selectedMilestoneIndex
            
            cell.configure(name: milestone.name, isSelected: isSelected)
            return cell
            
        } else { // 이슈 리스트
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IssueCardCell.identifier, for: indexPath) as! IssueCardCell
            let issue = filteredIssues[indexPath.item]
            
            cell.configure(
                title: issue.title,
                number: issue.number,
                author: issue.author,
                mileStone: nil
            )
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MilestoneViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 { // 마일스톤 이름 선택
            selectedMilestoneIndex = indexPath.item
            
            // UI 업데이트
            milestoneNamesCollectionView.reloadData()
            issueListCollectionView.reloadData()
            updateSectionHeader()
            
        } else { // 이슈 선택
            let issue = filteredIssues[indexPath.item]
            let issueDetailVC = IssueDetailViewController(issue: issue)
            navigationController?.pushViewController(issueDetailVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MilestoneViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 { // 마일스톤 이름들 (동적 크기)
            let milestone = milestones[indexPath.item]
            let width = milestone.name.size(withAttributes: [
                .font: UIFont.pretendard(.semiBold, size: 14)
            ]).width + 24 // 패딩 추가
            
            return CGSize(width: width, height: 36)
            
        } else { // 이슈 리스트
            let width = collectionView.frame.width - 40 // 좌우 여백 제외
            return CGSize(width: width, height: 110)
        }
    }
}

// MARK: - Data Models
struct MilestoneData {
    let id: String
    let name: String
    let issues: [IssueItem]
}

enum IssueFilter: CaseIterable {
    case all, open, closed
    
    var title: String {
        switch self {
        case .all: return "All"
        case .open: return "Open"
        case .closed: return "Closed"
        }
    }
}

// MARK: - Mock Data
extension MilestoneData {
    static let mockData: [MilestoneData] = [
        MilestoneData(
            id: "1",
            name: "Sprint 1",
            issues: [
                IssueItem(id: "1", title: "로그인 기능 구현", number: 45, author: "developer1"),
                IssueItem(id: "2", title: "UI 개선 작업", number: 44, author: "designer1"),
                IssueItem(id: "3", title: "API 연동 완료", number: 43, author: "backend-dev"),
                IssueItem(id: "4", title: "테스트 코드 작성", number: 42, author: "tester1"),
                IssueItem(id: "5", title: "버그 수정", number: 41, author: "developer2")
            ]
        ),
        
        MilestoneData(
            id: "2",
            name: "Sprint 2",
            issues: [
                IssueItem(id: "6", title: "프로필 페이지 구현", number: 40, author: "frontend-dev"),
                IssueItem(id: "7", title: "알림 기능 추가", number: 39, author: "developer3"),
                IssueItem(id: "8", title: "성능 최적화", number: 38, author: "performance-team")
            ]
        ),
        
        MilestoneData(
            id: "3",
            name: "Bug Fix Release",
            issues: [
                IssueItem(id: "9", title: "크래시 이슈 해결", number: 37, author: "qa-team"),
                IssueItem(id: "10", title: "메모리 누수 수정", number: 36, author: "developer4")
            ]
        ),
        
        MilestoneData(
            id: "4",
            name: "v2.0 Major Update",
            issues: [
                IssueItem(id: "11", title: "새로운 디자인 시스템", number: 35, author: "design-team"),
                IssueItem(id: "12", title: "다크모드 지원", number: 34, author: "ui-developer"),
                IssueItem(id: "13", title: "다국어 지원", number: 33, author: "localization-team"),
                IssueItem(id: "14", title: "접근성 개선", number: 32, author: "accessibility-team")
            ]
        ),
        
        MilestoneData(
            id: "5",
            name: "Empty Milestone",
            issues: [] // 빈 마일스톤 (테스트용)
        )
    ]
}
