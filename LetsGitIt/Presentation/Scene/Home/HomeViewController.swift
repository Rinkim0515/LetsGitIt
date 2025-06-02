//
//  ProfileViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 5/27/25.
//
// Presentation/Scene/Home/HomeViewController.swift
import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Dependencies (Clean Architecture)
    private let getCurrentUserUseCase: GetCurrentUserUseCase
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    // 컴포넌트들
    private let profileHeaderView = UserProfileHeaderView()
    private let milestoneSectionHeader = SectionHeaderView()
    private let milestonePreviewView = MilestonePreviewView(
        maxDisplayCount: 2,
        edgeInsets: MilestonePreviewView.EdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    )
    
    // TODO: 이슈 섹션도 추가 예정
    // private let issueSectionHeader = SectionHeaderView()
    // private let issuePreviewView = IssuePreviewView()
    
    // MARK: - Initialization (의존성 주입)
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
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "홈"
        view.backgroundColor = UIColor(named: "PrimaryBackground") ?? .systemBackground
        
        // 스크롤뷰 설정
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        // 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // 섹션 헤더 설정
        milestoneSectionHeader.configure(title: "중요한 마일스톤", showMoreButton: true)
        
        // 뷰 계층 구성
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // 스택뷰에 컴포넌트 추가
        stackView.addArrangedSubview(profileHeaderView)
        stackView.addArrangedSubview(createSpacerView(height: 24))
        stackView.addArrangedSubview(milestoneSectionHeader)
        stackView.addArrangedSubview(createSpacerView(height: 8))
        stackView.addArrangedSubview(milestonePreviewView)
        
        // TODO: 이슈 섹션 추가
        // stackView.addArrangedSubview(createSpacerView(height: 32))
        // stackView.addArrangedSubview(issueSectionHeader)
        // stackView.addArrangedSubview(createSpacerView(height: 8))
        // stackView.addArrangedSubview(issuePreviewView)
        
        // 하단 여백
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
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupActions() {
        // 마일스톤 섹션 헤더 더보기 버튼
        milestoneSectionHeader.onMoreTapped = { [weak self] in
            self?.navigateToMilestoneList()
        }
        
        // 마일스톤 카드 선택
        milestonePreviewView.onMilestoneSelected = { [weak self] milestone in
            self?.navigateToMilestoneDetail(milestone)
        }
    }
    
    // MARK: - Data Loading
    private func loadData() {
        loadUserProfile()
        loadMilestones()
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
        // TODO: 실제 UseCase로 교체
        // 현재는 Mock 데이터 사용
        let mockMilestones = MilestoneItem.mockData
        milestonePreviewView.updateMilestones(mockMilestones)
    }
    
    // MARK: - UI Update
    private func updateProfileHeader(with user: GitHubUser) {
        profileHeaderView.configure(
            name: user.name ?? "이름 없음",
            subtitle: "@\(user.login)",
            completedCount: 5, // TODO: 실제 데이터로 교체
            savedCount: 11076, // TODO: 실제 데이터로 교체
            statusText: "현재 코어 타임 09:30-15시 붕"
        )
    }
    
    // MARK: - Navigation
    private func navigateToMilestoneList() {
        // TODO: 마일스톤 전체 목록 화면으로 이동
        print("마일스톤 전체 목록으로 이동")
        
        // 예시:
        // let milestoneListVC = MilestoneListViewController()
        // navigationController?.pushViewController(milestoneListVC, animated: true)
    }
    
    private func navigateToMilestoneDetail(_ milestone: MilestoneItem) {
        // TODO: 마일스톤 상세 화면으로 이동
        print("마일스톤 상세로 이동: \(milestone.title)")
        
        // 예시:
        // let detailVC = MilestoneDetailViewController(milestone: milestone)
        // navigationController?.pushViewController(detailVC, animated: true)
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

// MARK: - Pull to Refresh (선택사항)
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

// MARK: - 사용 예시 (DIContainer에서)
/*
 DIContainer에서 사용법:
 
 func makeHomeViewController() -> HomeViewController {
     return HomeViewController(getCurrentUserUseCase: getCurrentUserUseCase)
 }
 
 // TabBarController에서 설정:
 let homeVC = DIContainer.shared.makeHomeViewController()
 homeVC.tabBarItem = UITabBarItem(
     title: "홈",
     image: UIImage(systemName: "house"),
     selectedImage: UIImage(systemName: "house.fill")
 )
 */
