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
    
    // 이슈 화면 (기존 MilestoneViewController의 구조 재활용)
    private let issueContainerView = UIView()
    private let milestoneNamesCollectionView: UICollectionView
    private let milestoneNamesFlowLayout = UICollectionViewFlowLayout()
    private let issueListCollectionView: UICollectionView
    private let issueListFlowLayout = UICollectionViewFlowLayout()
    private let sectionHeaderView = TitleHeaderView()
    private let floatingFilterView = FloatingFilterView()
    
    // 마일스톤 화면
    private let milestoneContainerView = UIView()
    private let milestoneCardCollectionView: UICollectionView
    private let milestoneCardFlowLayout = UICollectionViewFlowLayout()
    
    // MARK: - Data
    private var milestones: [MilestoneData] = []
    private var milestoneItems: [MilestoneItem] = []
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
    init(repository: GitHubRepository) {
        self.repository = repository
        self.milestoneNamesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: milestoneNamesFlowLayout)
        self.issueListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: issueListFlowLayout)
        self.milestoneCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: milestoneCardFlowLayout)
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
        setupCollectionViews()
        setupFloatingFilter()
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
        
        // 컨테이너 뷰들 설정
        containerView.backgroundColor = .clear
        issueContainerView.backgroundColor = .clear
        milestoneContainerView.backgroundColor = .clear
        
        // 이슈 화면 CollectionView 설정
        setupIssueCollectionViews()
        
        // 마일스톤 화면 CollectionView 설정
        setupMilestoneCollectionView()
        
        // 뷰 계층 구성
        view.addSubview(segmentedControl)
        view.addSubview(containerView)
        containerView.addSubview(issueContainerView)
        containerView.addSubview(milestoneContainerView)
        
        // 이슈 화면 구성
        issueContainerView.addSubview(milestoneNamesCollectionView)
        issueContainerView.addSubview(sectionHeaderView)
        issueContainerView.addSubview(issueListCollectionView)
        issueContainerView.addSubview(floatingFilterView)
        
        // 마일스톤 화면 구성
        milestoneContainerView.addSubview(milestoneCardCollectionView)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // 뒤로가기 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    private func setupIssueCollectionViews() {
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
    }
    
    private func setupMilestoneCollectionView() {
        // 마일스톤 카드 CollectionView
        milestoneCardFlowLayout.scrollDirection = .vertical
        milestoneCardFlowLayout.minimumLineSpacing = 16
        milestoneCardFlowLayout.minimumInteritemSpacing = 0
        
        milestoneCardCollectionView.backgroundColor = .clear
        milestoneCardCollectionView.showsVerticalScrollIndicator = false
        milestoneCardCollectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    private func setupConstraints() {
        [segmentedControl, containerView, issueContainerView, milestoneContainerView,
         milestoneNamesCollectionView, sectionHeaderView, issueListCollectionView, floatingFilterView,
         milestoneCardCollectionView].forEach {
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
            
            // 이슈 컨테이너
            issueContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            issueContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            issueContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            issueContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // 마일스톤 컨테이너
            milestoneContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            milestoneContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            milestoneContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            milestoneContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // === 이슈 화면 레이아웃 ===
            // 마일스톤 이름들
            milestoneNamesCollectionView.topAnchor.constraint(equalTo: issueContainerView.topAnchor, constant: 20),
            milestoneNamesCollectionView.leadingAnchor.constraint(equalTo: issueContainerView.leadingAnchor),
            milestoneNamesCollectionView.trailingAnchor.constraint(equalTo: issueContainerView.trailingAnchor),
            milestoneNamesCollectionView.heightAnchor.constraint(equalToConstant: 36),
            
            // 섹션 헤더
            sectionHeaderView.topAnchor.constraint(equalTo: milestoneNamesCollectionView.bottomAnchor, constant: 20),
            sectionHeaderView.leadingAnchor.constraint(equalTo: issueContainerView.leadingAnchor, constant: 20),
            sectionHeaderView.trailingAnchor.constraint(equalTo: issueContainerView.trailingAnchor, constant: -20),
            sectionHeaderView.heightAnchor.constraint(equalToConstant: 40),
            
            // 이슈 리스트
            issueListCollectionView.topAnchor.constraint(equalTo: sectionHeaderView.bottomAnchor, constant: 12),
            issueListCollectionView.leadingAnchor.constraint(equalTo: issueContainerView.leadingAnchor),
            issueListCollectionView.trailingAnchor.constraint(equalTo: issueContainerView.trailingAnchor),
            issueListCollectionView.bottomAnchor.constraint(equalTo: issueContainerView.bottomAnchor),
            
            // 플로팅 필터
            floatingFilterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingFilterView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingFilterView.widthAnchor.constraint(equalToConstant: 140),
            floatingFilterView.heightAnchor.constraint(equalToConstant: 40),
            
            // === 마일스톤 화면 레이아웃 ===
            milestoneCardCollectionView.topAnchor.constraint(equalTo: milestoneContainerView.topAnchor),
            milestoneCardCollectionView.leadingAnchor.constraint(equalTo: milestoneContainerView.leadingAnchor),
            milestoneCardCollectionView.trailingAnchor.constraint(equalTo: milestoneContainerView.trailingAnchor),
            milestoneCardCollectionView.bottomAnchor.constraint(equalTo: milestoneContainerView.bottomAnchor)
        ])
    }
    
    private func setupCollectionViews() {
        // 이슈 화면 CollectionViews
        milestoneNamesCollectionView.delegate = self
        milestoneNamesCollectionView.dataSource = self
        milestoneNamesCollectionView.register(MilestoneNameCell.self, forCellWithReuseIdentifier: MilestoneNameCell.id)
        
        issueListCollectionView.delegate = self
        issueListCollectionView.dataSource = self
        issueListCollectionView.register(IssueCardCell.self, forCellWithReuseIdentifier: IssueCardCell.id)
        
        // 마일스톤 화면 CollectionView
        milestoneCardCollectionView.delegate = self
        milestoneCardCollectionView.dataSource = self
        milestoneCardCollectionView.register(MilestoneCardCell.self, forCellWithReuseIdentifier: MilestoneCardCell.id)
    }
    
    private func setupFloatingFilter() {
        floatingFilterView.onFilterChanged = { [weak self] filter in
            self?.currentFilter = filter
            self?.issueListCollectionView.reloadData()
            self?.updateSectionHeader()
        }
    }
    
    // MARK: - Data Loading
    private func loadMockData() {
        // 이슈 데이터 (기존 MilestoneData)
        milestones = MilestoneData.mockData
        selectedMilestoneIndex = 0
        
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
            )
        ]
        
        // UI 업데이트
        milestoneNamesCollectionView.reloadData()
        issueListCollectionView.reloadData()
        milestoneCardCollectionView.reloadData()
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
    
    @objc private func segmentChanged() {
        updateContainerView()
    }
    
    private func updateContainerView() {
        let isIssueSelected = segmentedControl.selectedSegmentIndex == 0
        
        UIView.animate(withDuration: 0.3) {
            self.issueContainerView.alpha = isIssueSelected ? 1.0 : 0.0
            self.milestoneContainerView.alpha = isIssueSelected ? 0.0 : 1.0
            self.floatingFilterView.alpha = isIssueSelected ? 1.0 : 0.0
        } completion: { _ in
            self.issueContainerView.isHidden = !isIssueSelected
            self.milestoneContainerView.isHidden = isIssueSelected
            self.floatingFilterView.isHidden = !isIssueSelected
        }
    }
}

// MARK: - UICollectionViewDataSource
extension RepositoryDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 { // 마일스톤 이름들
            return milestones.count
        } else if collectionView.tag == 2 { // 이슈 리스트
            return filteredIssues.count
        } else { // 마일스톤 카드들
            return milestoneItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 { // 마일스톤 이름들
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MilestoneNameCell.id, for: indexPath) as! MilestoneNameCell
            let milestone = milestones[indexPath.item]
            let isSelected = indexPath.item == selectedMilestoneIndex
            
            cell.configure(name: milestone.name, isSelected: isSelected)
            return cell
            
        } else if collectionView.tag == 2 { // 이슈 리스트
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IssueCardCell.id, for: indexPath) as! IssueCardCell
            let issue = filteredIssues[indexPath.item]
            
            cell.configure(
                title: issue.title,
                number: issue.number,
                author: issue.author,
                mileStone: nil
            )
            return cell
            
        } else { // 마일스톤 카드들
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MilestoneCardCell.id, for: indexPath) as! MilestoneCardCell
            let milestone = milestoneItems[indexPath.item]
            
            cell.configure(
                title: milestone.title,
                description: milestone.description,
                tag: milestone.tag,
                tagColor: milestone.tagColor,
                dday: milestone.dday,
                ddayType: milestone.ddayType,
                progress: milestone.progress
            )
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension RepositoryDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 { // 마일스톤 이름 선택
            selectedMilestoneIndex = indexPath.item
            
            // UI 업데이트
            milestoneNamesCollectionView.reloadData()
            issueListCollectionView.reloadData()
            updateSectionHeader()
            
        } else if collectionView.tag == 2 { // 이슈 선택
            let issue = filteredIssues[indexPath.item]
            let issueDetailVC = IssueDetailViewController(issue: issue)
            issueDetailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(issueDetailVC, animated: true)
            
        } else { // 마일스톤 카드 선택
            let milestone = milestoneItems[indexPath.item]
            print("📍 마일스톤 선택됨: \(milestone.title)")
            // TODO: 마일스톤 상세 화면으로 이동
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RepositoryDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 { // 마일스톤 이름들 (동적 크기)
            let milestone = milestones[indexPath.item]
            let width = milestone.name.size(withAttributes: [
                .font: UIFont.pretendard(.semiBold, size: 14)
            ]).width + 24 // 패딩 추가
            
            return CGSize(width: width, height: 36)
            
        } else if collectionView.tag == 2 { // 이슈 리스트
            let width = collectionView.frame.width - 40 // 좌우 여백 제외
            return CGSize(width: width, height: 110)
            
        } else { // 마일스톤 카드들
            let width = collectionView.frame.width - 40 // 좌우 패딩 제외
            return CGSize(width: width, height: 120)
        }
    }
}
