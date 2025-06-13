//
//  MileStonePreview.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import UIKit

final class MilestonePreviewView: UIView {
    
    // MARK: - UI Components
    private let collectionView: UICollectionView
    private let flowLayout = UICollectionViewFlowLayout()
    
    // MARK: - Properties
    private var milestones: [GitHubMilestone] = []
    private let maxDisplayCount: Int
    
    // MARK: - Callbacks
    var onMilestoneSelected: ((GitHubMilestone) -> Void)?
    
    // MARK: - Properties
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
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Public Methods
    func updateMilestones(_ milestones: [GitHubMilestone]) {
        // 최대 표시 개수만큼만 저장
        self.milestones = Array(milestones.prefix(maxDisplayCount))
        collectionView.reloadData()
        updateHeight()
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
        collectionView.isScrollEnabled = false // 스크롤 비활성화 (미리보기용)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Cell 등록
        collectionView.register(MilestoneCardCell.self, forCellWithReuseIdentifier: MilestoneCardCell.id)
        collectionView.register(EmptyStateCell.self, forCellWithReuseIdentifier: EmptyStateCell.id)
        
        // 뷰 계층 구성
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
    
    // MARK: - Public Methods (오프셋 업데이트)
    func updateEdgeInsets(_ newInsets: EdgeInsets) {
        edgeInsets = newInsets
        
        // 기존 제약조건 제거 후 재설정
        collectionView.removeFromSuperview()
        addSubview(collectionView)
        setupConstraints()
    }
    
    private func updateHeight() {
        let itemCount = max(milestones.count, 1)
        let itemHeight: CGFloat = 120 // 카드 높이
        let spacing: CGFloat = 12
        let totalHeight = CGFloat(itemCount) * itemHeight + CGFloat(itemCount - 1) * spacing
        
        // 높이 제약조건 업데이트
        constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.isActive = false
            }
        }
        
        heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
}

// MARK: - UICollectionViewDataSource
extension MilestonePreviewView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return milestones.isEmpty ? 1 : milestones.count // ✅ 수정: Empty일 때도 1개 반환
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if milestones.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyStateCell.id, for: indexPath) as! EmptyStateCell
            cell.configure(message: "마일스톤이 없습니다")
            return cell
        }
        
        // 기존 로직
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MilestoneCardCell.id, for: indexPath) as! MilestoneCardCell
        let milestone = milestones[indexPath.item]
        cell.configure(with: milestone)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MilestonePreviewView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !milestones.isEmpty else { return }
        
        let milestone = milestones[indexPath.item]
        onMilestoneSelected?(milestone)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MilestonePreviewView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = 120 // 카드 높이
        return CGSize(width: width, height: height)
    }
}

// MARK: - Data Model
struct MilestoneItem {
    let id: String
    let title: String
    let description: String
    let tag: String
    let tagColor: UIColor
    let dday: String
    let ddayType: DDayType
    let progress: Double
}



