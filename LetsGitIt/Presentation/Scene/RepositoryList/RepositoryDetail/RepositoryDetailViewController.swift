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
    private var milestoneViewController: IssueListViewController?
    
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
        setupMilestoneViewController()
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
        
        view.addSubview(segmentedControl)
        view.addSubview(containerView)
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
    
    private func setupConstraints() {
        [segmentedControl, containerView].forEach {
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
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupMilestoneViewController() {
        milestoneViewController = IssueListViewController(repositoryName: repository.name)
        
        if let milestoneVC = milestoneViewController {
            addChild(milestoneVC)
            containerView.addSubview(milestoneVC.view)
            milestoneVC.didMove(toParent: self)
            
            milestoneVC.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                milestoneVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                milestoneVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                milestoneVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                milestoneVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
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
        
        if let milestoneVC = milestoneViewController {
            UIView.animate(withDuration: 0.3) {
                milestoneVC.view.alpha = isIssueSelected ? 1.0 : 0.5
            }
            
            // 이슈 상태일 때만 FloatingFilterView 보이게 하기
            // (MilestoneViewController 내부에서 처리)
        }
        
        // TODO: 세그먼트 1(마일스톤)일 때는 다른 뷰 표시
        if !isIssueSelected {
            // 마일스톤 전용 뷰 표시
            print("📍 마일스톤 화면으로 전환")
        }
    }
}
