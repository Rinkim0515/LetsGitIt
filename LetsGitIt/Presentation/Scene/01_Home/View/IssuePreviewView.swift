//
//  IssuePreviewView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import UIKit

// MARK: - IssuePreviewView
final class IssuePreviewView: UIView {
    
    // MARK: - UI Components
    private let collectionView: UICollectionView
    private let flowLayout = UICollectionViewFlowLayout()
    
    // MARK: - Properties
    private var issues: [GitHubIssue] = []
    private let maxDisplayCount: Int
    
    // MARK: - Callbacks
    var onIssueSelected: ((GitHubIssue) -> Void)?
    
    // MARK: - Edge Insets
    struct EdgeInsets {
        let top: CGFloat
        let left: CGFloat
        let bottom: CGFloat
        let right: CGFloat
        
        static let zero = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let `default` = EdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
    }
    
    private var edgeInsets: EdgeInsets
    
    // MARK: - Initializers
    init(maxDisplayCount: Int = 3, edgeInsets: EdgeInsets = .default) {
        self.maxDisplayCount = maxDisplayCount
        self.edgeInsets = edgeInsets
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.maxDisplayCount = 3
        self.edgeInsets = .default
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Public Methods
    func updateIssues(_ issues: [GitHubIssue]) {
        self.issues = Array(issues.prefix(maxDisplayCount))
        collectionView.reloadData()
        updateHeight()
    }
    
    func updateEdgeInsets(_ newInsets: EdgeInsets) {
        edgeInsets = newInsets
        collectionView.removeFromSuperview()
        addSubview(collectionView)
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // FlowLayout 설정
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 12
        flowLayout.minimumInteritemSpacing = 0
        
        // CollectionView 설정
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Cell 등록
        collectionView.register(IssueCardCell.self, forCellWithReuseIdentifier: IssueCardCell.id)
        collectionView.register(EmptyStateCell.self, forCellWithReuseIdentifier: EmptyStateCell.id)
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: edgeInsets.top),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: edgeInsets.left),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -edgeInsets.right),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -edgeInsets.bottom)
        ])
    }
    
    private func updateHeight() {
        let itemCount = max(issues.count, 1) // ✅ 최소 1개는 보장
        let itemHeight: CGFloat = 70
        let spacing: CGFloat = 12
        let totalHeight = CGFloat(itemCount) * itemHeight + CGFloat(max(itemCount - 1, 0)) * spacing
        
        constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.isActive = false
            }
        }
        
        heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
}

// MARK: - UICollectionViewDataSource
extension IssuePreviewView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return issues.isEmpty ? 1 : issues.count // ✅ 수정: Empty일 때도 1개 반환
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if issues.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyStateCell.id, for: indexPath) as! EmptyStateCell
            cell.configure(message: "미완료 이슈가 없습니다")
            return cell
        }
        
        // 기존 로직
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IssueCardCell.id, for: indexPath) as! IssueCardCell
        let issue = issues[indexPath.item]
        cell.configure(with: issue)
        return cell
    }}

// MARK: - UICollectionViewDelegate
extension IssuePreviewView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !issues.isEmpty else { return }
        
        let issue = issues[indexPath.item]
        onIssueSelected?(issue)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension IssuePreviewView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = 70
        return CGSize(width: width, height: height)
    }
}



