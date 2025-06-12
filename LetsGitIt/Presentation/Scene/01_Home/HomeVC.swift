//
//  ProfileViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 5/27/25.
//
// 이슈는 4개까지만 보여주고
// 마일스톤은 2개까지만

import UIKit

final class HomeVC: UIViewController, ErrorHandlingCapable, LoadingCapable {
    
    var coordinator: HomeCoordinator?
    
    // MARK: - Dependencies (Clean Architecture)
    private let getCurrentUserUseCase: GetCurrentUserUseCase
    private let getMilestonesUseCase: GetRepositoryMilestonesUseCase
    private let getIssuesUseCase: GetRepositoryIssuesUseCase
    private let profileHeaderView = UserProfileHeaderView()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let milestoneSectionHeader = TitleHeaderView()
    private let milestonePreviewView = MilestonePreviewView(
        maxDisplayCount: 2,
        edgeInsets: MilestonePreviewView.EdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    )
    
    private let issueSectionHeader = TitleHeaderView()
    private let issuePreviewView = IssuePreviewView(
        maxDisplayCount: 4,
        edgeInsets: IssuePreviewView.EdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    )
    
    private var selectedRepositoryName: String? {
        return UserDefaults.standard.string(forKey: "selected_repository_name")
    }
    
    private var selectedRepositoryOwner: String? {
        return UserDefaults.standard.string(forKey: "selected_repository_owner")
    }

    // MARK: - Initialization
    init(
        
        getCurrentUserUseCase: GetCurrentUserUseCase,
        getMilestonesUseCase: GetRepositoryMilestonesUseCase,
        getIssuesUseCase: GetRepositoryIssuesUseCase
    ) {
        
        self.getCurrentUserUseCase = getCurrentUserUseCase
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
    
    func setCoordinator(_ coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Navigation (✅ 수정)
    private func navigateToIssueDetail(_ issue: GitHubIssue) {
        coordinator?.showIssueDetail(issue)  // ✅ coordinator 통해 이동
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .backgroundSecondary
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .backgroundSecondary
        
        // 🔸 스택뷰 설정 (프로필 제외)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // 섹션 헤더들 설정
        milestoneSectionHeader.configure(title: "종료임박 마일스톤")
        issueSectionHeader.configure(title: "미완료 이슈")
        
        // 🔸 뷰 계층 구성 - 프로필과 스크롤뷰 분리
        view.addSubview(profileHeaderView)  // 상단 고정
        view.addSubview(scrollView)         // 프로필 아래
        scrollView.addSubview(stackView)
        
        // 🔸 스택뷰에 컴포넌트 추가 (프로필 제외)
        stackView.addArrangedSubview(UIView.createSpacerView(height: 10))
        
        // 마일스톤 섹션
        stackView.addArrangedSubview(milestoneSectionHeader)
        stackView.addArrangedSubview(UIView.createSpacerView(height: 8))
        stackView.addArrangedSubview(milestonePreviewView)
        
        // 이슈 섹션
        stackView.addArrangedSubview(UIView.createSpacerView(height: 10))
        stackView.addArrangedSubview(issueSectionHeader)
        stackView.addArrangedSubview(UIView.createSpacerView(height: 8))
        stackView.addArrangedSubview(issuePreviewView)
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
        // 마일스톤 카드 선택
        milestonePreviewView.onMilestoneSelected = { [weak self] milestone in
            self?.coordinator?.showMilestoneDetail(milestone)
        }
        
        // 이슈 카드 선택
        issuePreviewView.onIssueSelected = { [weak self] issue in
            self?.coordinator?.showIssueDetail(issue)
        }
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // 선택된 리포지토리가 있는지 확인
        guard let repositoryName = selectedRepositoryName,
              let repositoryOwner = selectedRepositoryOwner else {
            showDataLoadingErrorAlert {
                print("선택된 리포지토리가 없습니다.")
            }
            return
        }
        
        showLoading()
        
        // 병렬로 데이터 로딩
        Task {
            do {
                async let userTask = getCurrentUserUseCase.execute()
                async let milestonesTask = getMilestonesUseCase.executeForHome(
                    owner: repositoryOwner,
                    repo: repositoryName
                )
                async let issuesTask = getIssuesUseCase.executeForHome(
                    owner: repositoryOwner,
                    repo: repositoryName
                )
                
                let (user, milestones, issues) = try await (userTask, milestonesTask, issuesTask)
                
                await MainActor.run {
                    updateUI(user: user, milestones: milestones, issues: issues)
                    hideLoading()
                }
                
            } catch {
                await MainActor.run {
                    hideLoading()
                    showDataLoadingErrorAlert {
                        print("데이터 로딩 실패: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func updateUI(user: GitHubUser, milestones: [GitHubMilestone], issues: [GitHubIssue]) {
        // 프로필 헤더 업데이트
        updateProfileHeader(with: user)
        milestonePreviewView.updateMilestones(milestones)
        issuePreviewView.updateIssues(issues)
        
        print("✅ 데이터 로딩 완료: 마일스톤 \(milestones.count)개, 이슈 \(issues.count)개")
    }
    
    private func updateProfileHeader(with user: GitHubUser) {
        profileHeaderView.configure(
            name: user.name ?? user.login,
            subtitle: "1",
            completedCount: 5,
            savedCount: 11076,
            statusText: "현재 코어 타임 09:30:15 남았습니다."
        )
    }
    

    

    
    // MARK: - Navigation
    private func navigateToMilestoneList() {

    }
    
    private func navigateToIssueList() {
        print("📍 이슈 전체 목록으로 이동")
    }
    private func navigateToMilestoneDetail(_ milestone: MilestoneItem) {
        print("📍 마일스톤 상세로 이동: \(milestone.title)")
    }

    
}


