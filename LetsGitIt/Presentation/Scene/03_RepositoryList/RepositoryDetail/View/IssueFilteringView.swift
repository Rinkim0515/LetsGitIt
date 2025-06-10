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
    
    // MARK: - Callbacks
    var onIssueSelected: ((IssueItem) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        self.milestoneNamesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: milestoneNamesFlowLayout)
        self.issueListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: issueListFlowLayout)
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupCollectionViews()
        setupFloatingSegment()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            sectionHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sectionHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sectionHeaderView.heightAnchor.constraint(equalToConstant: 40),
            
            // 이슈 리스트
            issueListCollectionView.topAnchor.constraint(equalTo: sectionHeaderView.bottomAnchor, constant: 12),
            issueListCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            issueListCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            issueListCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 🔸 커스텀 플로팅 세그먼트 컨트롤
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
        
        // 그림자 효과 (투명도 때문에 더 강하게)
        floatingSegmentedControl.layer.shadowColor = UIColor.black.cgColor
        floatingSegmentedControl.layer.shadowOpacity = 0.5 // 0.3 → 0.5
        floatingSegmentedControl.layer.shadowOffset = CGSize(width: 0, height: 4) // 2 → 4
        floatingSegmentedControl.layer.shadowRadius = 12 // 8 → 12
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
            title: "\(selectedMilestone.name)의 이슈들 (\(filteredCount)개)",
            showMoreButton: false
        )
    }
    
    // MARK: - Public Methods
    func updateMilestones(_ milestones: [MilestoneData]) {
        self.milestones = milestones
        selectedMilestoneIndex = 0
        currentFilter = .all
        
        milestoneNamesCollectionView.reloadData()
        issueListCollectionView.reloadData()
        updateSectionHeader()
    }
    
    func updateFloatingSegmentPosition(bottomConstant: CGFloat) {
        floatingSegmentedControl.constraints.forEach { constraint in
            if constraint.firstAttribute == .bottom {
                // 🔸 기본적으로 더 아래 위치하도록 조정
                constraint.constant = bottomConstant - 40 // 추가로 40pt 더 아래로
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
            
            cell.configure(name: milestone.name, isSelected: isSelected)
            return cell
            
        } else { // 이슈 리스트
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IssueCardCell.id, for: indexPath) as! IssueCardCell
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
