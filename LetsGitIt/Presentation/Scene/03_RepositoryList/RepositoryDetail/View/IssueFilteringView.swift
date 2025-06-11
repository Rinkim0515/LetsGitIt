//
//  IssueFilteringView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/9/25.
//

import UIKit

final class IssueFilteringView: UIView {
    
    // MARK: - UI Components
    private let milestoneNamesCollectionView: UICollectionView
    private let milestoneNamesFlowLayout = UICollectionViewFlowLayout()
    private let issueListCollectionView: UICollectionView
    private let issueListFlowLayout = UICollectionViewFlowLayout()
    private let sectionHeaderView = TitleHeaderView()
    private let floatingSegmentedControl = UISegmentedControl(items: ["All", "Open", "Closed"])
    
    // MARK: - Data (GitHubMilestone으로 통일)
    private var milestones: [GitHubMilestone] = []
    private var selectedMilestoneIndex: Int = 0
    private var currentFilter: IssueFilter = .all
    
    // ✅ Mock data로 이슈 생성 (GitHubMilestone에는 issues 프로퍼티가 없으므로)
    private var allIssues: [GitHubIssue] = []
    
    private var filteredIssues: [GitHubIssue] {
        guard selectedMilestoneIndex < milestones.count else { return [] }
        let selectedMilestone = milestones[selectedMilestoneIndex]
        
        // ✅ 선택된 마일스톤의 이슈들만 필터링
        let milestoneIssues = allIssues.filter { issue in
            issue.milestone?.id == selectedMilestone.id
        }
        
        switch currentFilter {
        case .all:
            return milestoneIssues
        case .open:
            return milestoneIssues.filter { $0.isOpen }
        case .closed:
            return milestoneIssues.filter { !$0.isOpen }
        }
    }
    
    // MARK: - Callbacks
    var onIssueSelected: ((GitHubIssue) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        self.milestoneNamesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: milestoneNamesFlowLayout)
        self.issueListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: issueListFlowLayout)
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupCollectionViews()
        setupFloatingSegment()
        loadMockData() // ✅ Mock 데이터 로드
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Mock Data Loading
    private func loadMockData() {
        // ✅ MockData에서 마일스톤과 이슈 가져오기
        milestones = MockData.sampleMilestones
        allIssues = MockData.sampleIssues
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        
        // 마일스톤 이름들 CollectionView
        milestoneNamesFlowLayout.scrollDirection = .horizontal
        milestoneNamesFlowLayout.minimumLineSpacing = 12
        milestoneNamesFlowLayout.minimumInteritemSpacing = 0
        
        milestoneNamesCollectionView.backgroundColor = .clear
        milestoneNamesCollectionView.showsHorizontalScrollIndicator = false
        milestoneNamesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        milestoneNamesCollectionView.tag = 1
        
        // 이슈 리스트 CollectionView
        issueListFlowLayout.scrollDirection = .vertical
        issueListFlowLayout.minimumLineSpacing = 12
        issueListFlowLayout.minimumInteritemSpacing = 0
        
        issueListCollectionView.backgroundColor = .clear
        issueListCollectionView.showsVerticalScrollIndicator = false
        issueListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        issueListCollectionView.tag = 2
        
        // 뷰 계층 구성
        addSubview(milestoneNamesCollectionView)
        addSubview(sectionHeaderView)
        addSubview(issueListCollectionView)
        addSubview(floatingSegmentedControl)
    }
    
    private func setupConstraints() {
        [milestoneNamesCollectionView, sectionHeaderView, issueListCollectionView, floatingSegmentedControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 마일스톤 이름들
            milestoneNamesCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            milestoneNamesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            milestoneNamesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            milestoneNamesCollectionView.heightAnchor.constraint(equalToConstant: 36),
            
            // 섹션 헤더
            sectionHeaderView.topAnchor.constraint(equalTo: milestoneNamesCollectionView.bottomAnchor, constant: 20),
            sectionHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sectionHeaderView.heightAnchor.constraint(equalToConstant: 40),
            
            // 이슈 리스트
            issueListCollectionView.topAnchor.constraint(equalTo: sectionHeaderView.bottomAnchor, constant: 10),
            issueListCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            issueListCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            issueListCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 플로팅 세그먼트 컨트롤
            floatingSegmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            floatingSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            floatingSegmentedControl.widthAnchor.constraint(equalToConstant: 280),
            floatingSegmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCollectionViews() {
        // 마일스톤 이름들
        milestoneNamesCollectionView.delegate = self
        milestoneNamesCollectionView.dataSource = self
        milestoneNamesCollectionView.register(MilestoneNameCell.self, forCellWithReuseIdentifier: MilestoneNameCell.id)
        
        // 이슈 리스트
        issueListCollectionView.delegate = self
        issueListCollectionView.dataSource = self
        issueListCollectionView.register(IssueCardCell.self, forCellWithReuseIdentifier: IssueCardCell.id)
    }
    
    private func setupFloatingSegment() {
        // 세그먼트 컨트롤 스타일 설정
        floatingSegmentedControl.selectedSegmentIndex = 0
        
        floatingSegmentedControl.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        floatingSegmentedControl.selectedSegmentTintColor = UIColor.white.withAlphaComponent(0.7)
        floatingSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        floatingSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        
        floatingSegmentedControl.layer.cornerRadius = 60
        floatingSegmentedControl.clipsToBounds = true
        
        // 그림자 효과
        floatingSegmentedControl.layer.shadowColor = UIColor.black.cgColor
        floatingSegmentedControl.layer.shadowOpacity = 0.5
        floatingSegmentedControl.layer.shadowOffset = CGSize(width: 0, height: 4)
        floatingSegmentedControl.layer.shadowRadius = 12
        floatingSegmentedControl.layer.masksToBounds = false
        
        // 이벤트 연결
        floatingSegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged() {
        let selectedIndex = floatingSegmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            currentFilter = .all
        case 1:
            currentFilter = .open
        case 2:
            currentFilter = .closed
        default:
            currentFilter = .all
        }
        
        issueListCollectionView.reloadData()
        updateSectionHeader()
    }
    
    private func updateSectionHeader() {
        guard selectedMilestoneIndex < milestones.count else { return }
        let selectedMilestone = milestones[selectedMilestoneIndex]
        let filteredCount = filteredIssues.count
        
        sectionHeaderView.configure(
            title: "\(selectedMilestone.title)의 이슈들 (\(filteredCount)개)",
            showMoreButton: false
        )
    }
    
    // MARK: - Public Methods (✅ 타입 수정)
    func updateMilestones(_ milestones: [GitHubMilestone]) {
        self.milestones = milestones
        selectedMilestoneIndex = 0
        currentFilter = .all
        
        milestoneNamesCollectionView.reloadData()
        issueListCollectionView.reloadData()
        updateSectionHeader()
    }
    
    // ✅ 이슈 업데이트 메서드 추가
    func updateIssues(_ issues: [GitHubIssue]) {
        self.allIssues = issues
        issueListCollectionView.reloadData()
        updateSectionHeader()
    }
    
    func updateFloatingSegmentPosition(bottomConstant: CGFloat) {
        floatingSegmentedControl.constraints.forEach { constraint in
            if constraint.firstAttribute == .bottom {
                constraint.constant = bottomConstant - 40
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension IssueFilteringView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 { // 마일스톤 이름들
            return milestones.count
        } else { // 이슈 리스트
            return filteredIssues.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 { // 마일스톤 이름들
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MilestoneNameCell.id, for: indexPath) as! MilestoneNameCell
            let milestone = milestones[indexPath.item]
            let isSelected = indexPath.item == selectedMilestoneIndex
            
            cell.configure(name: milestone.title, isSelected: isSelected) // ✅ .name → .title
            return cell
            
        } else { // 이슈 리스트
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IssueCardCell.id, for: indexPath) as! IssueCardCell
            let issue = filteredIssues[indexPath.item]
            
            cell.configure(with: issue)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension IssueFilteringView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 { // 마일스톤 이름 선택
            selectedMilestoneIndex = indexPath.item
            
            // UI 업데이트
            milestoneNamesCollectionView.reloadData()
            issueListCollectionView.reloadData()
            updateSectionHeader()
            
        } else { // 이슈 선택
            let issue = filteredIssues[indexPath.item]
            onIssueSelected?(issue)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension IssueFilteringView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 { // 마일스톤 이름들 (동적 크기)
            let milestone = milestones[indexPath.item]
            let width = milestone.title.size(withAttributes: [ // ✅ .name → .title
                .font: UIFont.pretendard(.semiBold, size: 14)
            ]).width + 24 // 패딩 추가
            
            return CGSize(width: width, height: 36)
            
        } else { // 이슈 리스트
            let width = collectionView.frame.width - 40 // 좌우 여백 제외
            return CGSize(width: width, height: 110)
        }
    }
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
