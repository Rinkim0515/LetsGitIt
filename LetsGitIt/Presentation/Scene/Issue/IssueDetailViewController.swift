//
//  IssueViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//


//
//  IssueDetailViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class IssueDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let issue: IssueItem
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    // 1번째 섹션: 이슈 본문 (고정된 단일 뷰)
    private let issueContentView = UIView()
    private let issueContentCell = ContentCell()
    
    // 2번째 섹션: 이슈 세부정보
    private let issueDetailSection = IssueDetailSection()
    
    // 구분선
    private let separatorView = UIView()
    
    // 3번째 섹션: 코멘트들
    private let commentSectionHeader = SectionHeaderView()
    private let commentCollectionView: UICollectionView
    private let flowLayout = UICollectionViewFlowLayout()
    
    // MARK: - Data
    private var comments: [CommentItem] = []
    
    // MARK: - Initialization
    init(issue: IssueItem) {
        self.issue = issue
        self.commentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.issueContentCell.configure(with: )
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
        setupCommentCollectionView()
        loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .backgroundSecondary
        
        // 스크롤뷰 설정
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        // 메인 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // 구분선 설정
        separatorView.backgroundColor = UIColor(named: "Separator") ?? .separator
        
        // 코멘트 섹션 헤더 설정
        commentSectionHeader.configure(title: "코멘트", showMoreButton: false)
        
        // 1번째 섹션: 이슈 본문 뷰 설정
        setupIssueContentView()
        
        // 뷰 계층 구성
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // 스택뷰에 컴포넌트 추가 (올바른 순서)
        stackView.addArrangedSubview(createSpacerView(height: 16))
        stackView.addArrangedSubview(issueContentView)      // 1번째 섹션: 이슈 본문
        stackView.addArrangedSubview(issueDetailSection)    // 2번째 섹션: 세부정보
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(commentSectionHeader)  // 3번째 섹션 헤더
        stackView.addArrangedSubview(createSpacerView(height: 8))
        stackView.addArrangedSubview(commentCollectionView) // 3번째 섹션: 코멘트들
        stackView.addArrangedSubview(createSpacerView(height: 32))
    }
    
    private func setupIssueContentView() {
        // 이슈 본문을 담을 컨테이너 뷰
        issueContentView.backgroundColor = .clear
        
        // ContentCell을 뷰로 사용 (CollectionView 없이)
        issueContentView.addSubview(issueContentCell)
        issueContentCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            issueContentCell.topAnchor.constraint(equalTo: issueContentView.topAnchor),
            issueContentCell.leadingAnchor.constraint(equalTo: issueContentView.leadingAnchor),
            issueContentCell.trailingAnchor.constraint(equalTo: issueContentView.trailingAnchor),
            issueContentCell.bottomAnchor.constraint(equalTo: issueContentView.bottomAnchor)
        ])
    }
    
    private func setupConstraints() {
        [scrollView, stackView, separatorView].forEach {
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
            
            // 구분선
            separatorView.heightAnchor.constraint(equalToConstant: 8),
            
            // 코멘트 CollectionView 높이 (동적 계산)
            commentCollectionView.heightAnchor.constraint(equalToConstant: calculateCommentsHeight())
        ])
    }
    
    private func setupNavigationBar() {
        title = "이슈 상세"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // 뒤로가기 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        // 공유 버튼 (선택사항)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped)
        )
    }
    
    private func setupCommentCollectionView() {
        // FlowLayout 설정
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 12
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.estimatedItemSize = CGSize(width: view.frame.width, height: 100)
        
        // CollectionView 설정
        commentCollectionView.backgroundColor = .clear
        commentCollectionView.showsVerticalScrollIndicator = false
        commentCollectionView.isScrollEnabled = false // 메인 스크롤뷰 안에 있으므로
        commentCollectionView.delegate = self
        commentCollectionView.dataSource = self
        
        // 셀 등록 (CommentCell 사용 - 기존 이름 유지)
        commentCollectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.identifier)
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // 1번째 섹션: 이슈 본문 설정
        issueContentCell.configure(
            author: issue.author,
            createdAt: Date(), // Mock 데이터
            content: "**버그 발생!** 앱이 _정말_ 이상하게 동작합니다.\n\n재현 방법:\n1. 로그인\n2. **설정** 페이지 이동\n3. `다크모드` 버튼 클릭\n\n급하게 수정 부탁드립니다! 🙏"
        )
        
        // 2번째 섹션: 이슈 세부정보 설정
        issueDetailSection.configure(
            labels: ["FEAT"], // Mock 데이터
            assignee: "담당자없음",
            project: "PC Web Dev",
            milestone: "Sprint 1",
            createdDate: "2025. 05. 14",
            modifiedDate: "2025. 05. 14"
        )
        
        // 3번째 섹션: 코멘트들 로드
        comments = CommentItem.mockComments
        commentCollectionView.reloadData()
        updateCommentsHeight()
    }
    
    // MARK: - Helper Methods
    private func createSpacerView(height: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        return spacer
    }
    
    private func calculateCommentsHeight() -> CGFloat {
        let commentCount = comments.count
        let estimatedCommentHeight: CGFloat = 150 // 예상 코멘트 높이
        let spacing: CGFloat = 12
        
        return CGFloat(commentCount) * estimatedCommentHeight + CGFloat(max(0, commentCount - 1)) * spacing
    }
    
    private func updateCommentsHeight() {
        // 실제 셀 높이 계산 후 업데이트
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.commentCollectionView.layoutIfNeeded()
            let contentHeight = self.commentCollectionView.collectionViewLayout.collectionViewContentSize.height
            
            // 높이 제약조건 업데이트
            self.commentCollectionView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = max(contentHeight, 100) // 최소 높이 보장
                }
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareButtonTapped() {
        // TODO: 이슈 공유 기능
        print("🔗 이슈 공유하기")
    }
}

// MARK: - UICollectionViewDataSource
extension IssueDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count // 실제 코멘트들만
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
        let comment = comments[indexPath.item]
        
        // 기존 CommentCell의 메서드 사용
        cell.configure(with: comment)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension IssueDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 200) // 임시 고정 높이
    }
}
