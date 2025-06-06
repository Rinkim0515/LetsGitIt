//
//  IssueViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//


import UIKit

final class IssueDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let issue: IssueItem
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    // 이슈 헤더 섹션
    private let issueHeaderView = UIView()
    
    // 구분선
    private let separatorView = UIView()
    
    // 코멘트 섹션 헤더
    private let commentSectionHeader = SectionHeaderView()
    
    // 코멘트 CollectionView
    private let commentCollectionView: UICollectionView
    private let flowLayout = UICollectionViewFlowLayout()
    
    // MARK: - Initialization
    init(issue: IssueItem) {
        self.issue = issue
        self.commentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
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
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // 구분선 설정
        separatorView.backgroundColor = .separator
        
        // 코멘트 섹션 헤더 설정
        commentSectionHeader.configure(title: "코멘트", showMoreButton: false)
        
        // 뷰 계층 구성
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // 스택뷰에 컴포넌트 추가
        stackView.addArrangedSubview(issueHeaderView)
        stackView.addArrangedSubview(createSpacerView(height: 16))
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(createSpacerView(height: 16))
        stackView.addArrangedSubview(commentSectionHeader)
        stackView.addArrangedSubview(createSpacerView(height: 8))
        stackView.addArrangedSubview(commentCollectionView)
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
        
        // 셀 등록
        commentCollectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // 이슈 헤더 정보 설정
//        issueHeaderView.configure(
//            title: issue.title,
//            number: issue.number,
//            author: issue.author,
//            milestone: "Sprint 1",
//            createdDate: "2025. 05. 14",
//            modifiedDate: "2025. 05. 14"
//        )
        
        // 코멘트 로드
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
        let commentCount = CommentItem.mockComments.count
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
}

// MARK: - UICollectionViewDataSource
extension IssueDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CommentItem.mockComments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
        let comment = CommentItem.mockComments[indexPath.item]
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

