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
    
    private let issueSectionHeader = SectionHeaderView()
    // 1번째 섹션: 이슈 본문용 CollectionView (셀 1개)
    private let issueContentCollectionView: UICollectionView
    private let issueContentFlowLayout = UICollectionViewFlowLayout()
    
    // 2번째 섹션: 이슈 세부정보
    private let issueDetailSection = IssueDetailSection()
    
    // 구분선
    private let separatorView = UIView()
    
    // 3번째 섹션: 코멘트들
    private let commentSectionHeader = SectionHeaderView()
    private let commentCollectionView: UICollectionView
    private let commentFlowLayout = UICollectionViewFlowLayout()
    
    // MARK: - Data
    private var issueContent: CommentData?
    private var comments: [CommentItem] = []
    
    // MARK: - Initialization
    init(issue: IssueItem) {
        self.issue = issue
        self.issueContentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: issueContentFlowLayout)
        self.commentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: commentFlowLayout)
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
        issueSectionHeader.configure(title: "이슈상세", showMoreButton: false)
        // 코멘트 섹션 헤더 설정
        commentSectionHeader.configure(title: "코멘트", showMoreButton: false)
        
        // 뷰 계층 구성
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // 스택뷰에 컴포넌트 추가
        stackView.addArrangedSubview(createSpacerView(height: 8))
        stackView.addArrangedSubview(issueSectionHeader)
        stackView.addArrangedSubview(issueContentCollectionView) // 1번째 섹션: 이슈 본문 (1개 셀)
        stackView.addArrangedSubview(issueDetailSection)         // 2번째 섹션: 세부정보
        
        stackView.addArrangedSubview(commentSectionHeader)       // 3번째 섹션 헤더
        
        stackView.addArrangedSubview(commentCollectionView)      // 3번째 섹션: 코멘트들
        stackView.addArrangedSubview(createSpacerView(height: 32))
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
            
            // 이슈 본문 CollectionView 높이 (1개 셀 고정)
            issueContentCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            // 코멘트 CollectionView 높이 (동적 계산)
            commentCollectionView.heightAnchor.constraint(equalToConstant: calculateCommentsHeight())
        ])
    }
    
    private func setupNavigationBar() {
        title = "#45"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // 뒤로가기 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        // 공유 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped)
        )
    }
    
    private func setupCollectionViews() {
        // 1번째 섹션: 이슈 본문 CollectionView 설정
        issueContentFlowLayout.scrollDirection = .vertical
        issueContentFlowLayout.minimumLineSpacing = 0
        issueContentFlowLayout.minimumInteritemSpacing = 0
        
        issueContentCollectionView.backgroundColor = .clear
        issueContentCollectionView.showsVerticalScrollIndicator = false
        issueContentCollectionView.isScrollEnabled = false
        issueContentCollectionView.delegate = self
        issueContentCollectionView.dataSource = self
        issueContentCollectionView.tag = 1 // 구분용 태그
        
        // 3번째 섹션: 코멘트 CollectionView 설정
        commentFlowLayout.scrollDirection = .vertical
        commentFlowLayout.minimumLineSpacing = 12
        commentFlowLayout.minimumInteritemSpacing = 0
        
        commentCollectionView.backgroundColor = .clear
        commentCollectionView.showsVerticalScrollIndicator = false
        commentCollectionView.isScrollEnabled = false
        commentCollectionView.delegate = self
        commentCollectionView.dataSource = self
        commentCollectionView.tag = 2 // 구분용 태그
        
        // 셀 등록 (두 CollectionView 모두 CommentCell 사용)
        issueContentCollectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.identifier)
        commentCollectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.identifier)
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // 1번째 섹션: 이슈 본문 데이터 준비
        issueContent = CommentData(
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
        
        // CollectionView 리로드
        issueContentCollectionView.reloadData()
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
        let estimatedCommentHeight: CGFloat = 150
        let spacing: CGFloat = 12
        
        return CGFloat(commentCount) * estimatedCommentHeight + CGFloat(max(0, commentCount - 1)) * spacing
    }
    
    private func updateCommentsHeight() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.commentCollectionView.layoutIfNeeded()
            let contentHeight = self.commentCollectionView.collectionViewLayout.collectionViewContentSize.height
            
            self.commentCollectionView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = max(contentHeight, 100)
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
        print("🔗 이슈 공유하기")
    }
}

// MARK: - UICollectionViewDataSource
extension IssueDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 { // 이슈 본문 CollectionView
            return issueContent != nil ? 1 : 0
        } else { // 코멘트 CollectionView
            return comments.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
        
        if collectionView.tag == 1 { // 이슈 본문 CollectionView
            if let issueContent = issueContent {
                cell.configure(
                    author: issueContent.author,
                    createdAt: issueContent.createdAt,
                    content: issueContent.content
                )
            }
        } else { // 코멘트 CollectionView
            let comment = comments[indexPath.item]
            cell.configure(with: comment)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension IssueDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        
        if collectionView.tag == 1 { // 이슈 본문 CollectionView
            return CGSize(width: width, height: 200) // 이슈 본문 고정 높이
        } else { // 코멘트 CollectionView
            return CGSize(width: width, height: 200) // 코멘트 고정 높이
        }
    }
}

// MARK: - CommentData Model
struct CommentData {
    let author: String
    let createdAt: Date
    let content: String
}
