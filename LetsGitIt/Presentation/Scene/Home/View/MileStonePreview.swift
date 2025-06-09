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
    private var milestones: [MilestoneItem] = []
    private let maxDisplayCount: Int
    
    // MARK: - Callbacks
    var onMilestoneSelected: ((MilestoneItem) -> Void)?
    
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
    func updateMilestones(_ milestones: [MilestoneItem]) {
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
        // 아이템 개수에 따라 높이 동적 조정
        let itemCount = milestones.count
        guard itemCount > 0 else { return }
        
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
        return milestones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MilestoneCardCell.id, for: indexPath) as! MilestoneCardCell
        
        let milestone = milestones[indexPath.item]
        
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

// MARK: - UICollectionViewDelegate
extension MilestonePreviewView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

// MARK: - Mock Data
extension MilestoneItem {
    static let mockData = [
        MilestoneItem(
            id: "1",
            title: "마일스톤 제목",
            description: "마일스톤 내용마일스톤 내용마일스톤 내용마일스톤 내용마일스톤 내용",
            tag: "Mobile App",
            tagColor: .systemPink,
            dday: "D+3",
            ddayType: .overdue,
            progress: 0.7
        ),
        MilestoneItem(
            id: "2",
            title: "마일스톤 제목",
            description: "마일스톤 내용마일스톤 내용마일스톤 내용마일스톤 내용마일스톤 내용",
            tag: "PC Web",
            tagColor: .systemBlue,
            dday: "D-3",
            ddayType: .upcoming,
            progress: 0.4
        ),
        MilestoneItem(
            id: "3",
            title: "추가 마일스톤",
            description: "세 번째 마일스톤 설명입니다",
            tag: "Backend",
            tagColor: .systemGreen,
            dday: "D-7",
            ddayType: .upcoming,
            progress: 0.2
        )
    ]
}

// MARK: - 사용 예시
/*
 사용법:
 
 let milestonePreview = MilestonePreviewView(maxDisplayCount: 2)
 
 // 데이터 업데이트
 milestonePreview.updateMilestones(MilestoneItem.mockData)
 
 // 마일스톤 선택 이벤트
 milestonePreview.onMilestoneSelected = { milestone in
     print("선택된 마일스톤: \(milestone.title)")
     // 상세 화면으로 이동
 }
 
 // StackView에 추가
 stackView.addArrangedSubview(milestonePreview)
 */
