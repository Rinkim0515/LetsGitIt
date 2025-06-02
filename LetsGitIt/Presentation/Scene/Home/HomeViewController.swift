//
//  ProfileViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 5/27/25.
//
// 이슈는 4개까지만 보여주고
// 마일스톤은 2개까지만


import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Dependencies (Clean Architecture)
    private let getCurrentUserUseCase: GetCurrentUserUseCase
    
    // MARK: - UI Components
    // 🔸 프로필 헤더 (고정)
    private let profileHeaderView = UserProfileHeaderView()
    
    // 🔸 스크롤 가능한 컨텐츠
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    // 마일스톤 섹션
    private let milestoneSectionHeader = SectionHeaderView()
    private let milestonePreviewView = MilestonePreviewView(
        maxDisplayCount: 2,
        edgeInsets: MilestonePreviewView.EdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    )
    
    // 이슈 섹션
    private let issueSectionHeader = SectionHeaderView()
    private let issuePreviewView = IssuePreviewView(
        maxDisplayCount: 2,
        edgeInsets: IssuePreviewView.EdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    )
    
    // MARK: - Initialization
    init(getCurrentUserUseCase: GetCurrentUserUseCase) {
        self.getCurrentUserUseCase = getCurrentUserUseCase
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
        setupActions()
        loadData()
        self.view.backgroundColor = .cardBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .backgroundSecondary
        
        // 🔸 스크롤뷰 설정
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .backgroundSecondary
        
        // 🔸 스택뷰 설정 (프로필 제외)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // 섹션 헤더들 설정
        milestoneSectionHeader.configure(title: "종료임박 마일스톤", showMoreButton: true)
        issueSectionHeader.configure(title: "미완료 이슈", showMoreButton: false)
        
        // 🔸 뷰 계층 구성 - 프로필과 스크롤뷰 분리
        view.addSubview(profileHeaderView)  // 상단 고정
        view.addSubview(scrollView)         // 프로필 아래
        scrollView.addSubview(stackView)
        
        // 🔸 스택뷰에 컴포넌트 추가 (프로필 제외)
        stackView.addArrangedSubview(createSpacerView(height: 10))
        
        // 마일스톤 섹션
        stackView.addArrangedSubview(milestoneSectionHeader)
        stackView.addArrangedSubview(createSpacerView(height: 8))
        stackView.addArrangedSubview(milestonePreviewView)
        
        // 이슈 섹션
        stackView.addArrangedSubview(createSpacerView(height: 10))
        stackView.addArrangedSubview(issueSectionHeader)
        stackView.addArrangedSubview(createSpacerView(height: 8))
        stackView.addArrangedSubview(issuePreviewView)
        
        // 하단 여백
        stackView.addArrangedSubview(createSpacerView(height: 32))
    }
    
    private func setupConstraints() {
        [profileHeaderView, scrollView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 🔸 프로필 헤더 (상단 고정)
            profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // 🔸 스크롤뷰 (프로필 아래부터 시작)
            scrollView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 🔸 스택뷰 (스크롤뷰 내부)
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupActions() {
        // 마일스톤 섹션 헤더 더보기 버튼
        milestoneSectionHeader.onMoreTapped = { [weak self] in
            self?.navigateToMilestoneList()
        }
        
        // 이슈 섹션 헤더 더보기 버튼
        issueSectionHeader.onMoreTapped = { [weak self] in
            self?.navigateToIssueList()
        }
        
        // 마일스톤 카드 선택
        milestonePreviewView.onMilestoneSelected = { [weak self] milestone in
            self?.navigateToMilestoneDetail(milestone)
        }
        
        // 이슈 카드 선택
        issuePreviewView.onIssueSelected = { [weak self] issue in
            self?.navigateToIssueDetail(issue)
        }
    }
    
    // MARK: - Data Loading
    private func loadData() {
        loadUserProfile()
        loadMilestones()
        loadIssues()
    }
    
    private func loadUserProfile() {
        Task {
            do {
                let user = try await getCurrentUserUseCase.execute()
                await MainActor.run {
                    updateProfileHeader(with: user)
                }
            } catch {
                await MainActor.run {
                    showError("프로필 정보를 불러오지 못했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadMilestones() {
        let mockMilestones = MilestoneItem.mockData
        milestonePreviewView.updateMilestones(mockMilestones)
    }
    
    private func loadIssues() {
        let mockIssues = IssueItem.mockData
        issuePreviewView.updateIssues(mockIssues)
    }
    
    // MARK: - UI Update
    private func updateProfileHeader(with user: GitHubUser) {
        profileHeaderView.configure(
            name: user.name ?? "이름 없음",
            subtitle: "@\(user.login)",
            completedCount: 5,
            savedCount: 11076,
            statusText: "현재 코어 타임 09:30:15 남았습니다."
        )
    }
    
    // MARK: - Navigation
    private func navigateToMilestoneList() {
        print("📍 마일스톤 전체 목록으로 이동")
    }
    
    private func navigateToIssueList() {
        print("📍 이슈 전체 목록으로 이동")
    }
    
    private func navigateToMilestoneDetail(_ milestone: MilestoneItem) {
        print("📍 마일스톤 상세로 이동: \(milestone.title)")
    }
    
    private func navigateToIssueDetail(_ issue: IssueItem) {
        print("📍 이슈 상세로 이동: #\(issue.number) \(issue.title)")
    }
    
    // MARK: - Helper Methods
    private func createSpacerView(height: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        return spacer
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Pull to Refresh
extension HomeViewController {
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh() {
        loadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - 레이아웃 구조
/*
 🏗️ 새로운 레이아웃 구조:
 
 📱 HomeViewController
 ├── 👤 UserProfileHeaderView (상단 고정) ✨
 └── ScrollView (프로필 아래부터 스크롤)
     └── StackView
         ├── ➖ Spacer (24pt)
         ├── 📋 SectionHeaderView ("중요한 마일스톤")
         ├── ➖ Spacer (8pt)
         ├── 🎯 MilestonePreviewView
         ├── ➖ Spacer (32pt)
         ├── 📋 SectionHeaderView ("미완료 이슈")
         ├── ➖ Spacer (8pt)
         ├── 🐛 IssuePreviewView
         └── ➖ Spacer (32pt)
 
 ✨ 변경사항:
 - 프로필 헤더가 상단에 고정됨
 - 스크롤할 때 프로필은 보이고 컨텐츠만 스크롤됨
 - 더 명확한 레이아웃 분리
 */
