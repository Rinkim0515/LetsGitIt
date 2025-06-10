//
//  MilestoneListView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/9/25.
//

import UIKit

final class MilestoneListView: UIView {
    
    // MARK: - UI Components
    private let collectionView: UICollectionView
    private let flowLayout = UICollectionViewFlowLayout()
    
    // MARK: - Data
    private var milestones: [GitHubMilestone] = []
    
    // MARK: - Callbacks
    var onMilestoneSelected: ((GitHubMilestone) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        
        // FlowLayout 설정
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 0
        
        // CollectionView 설정
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // MilestoneCardCell 등록
        collectionView.register(MilestoneCardCell.self, forCellWithReuseIdentifier: MilestoneCardCell.id)
    }
    
    // MARK: - Public Methods
    func updateMilestones(_ milestones: [GitHubMilestone]) {
        self.milestones = milestones
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension MilestoneListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return milestones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MilestoneCardCell.id, for: indexPath) as! MilestoneCardCell
        let milestone = milestones[indexPath.item]
        
        cell.configure(with: milestone)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MilestoneListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let milestone = milestones[indexPath.item]
        onMilestoneSelected?(milestone)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MilestoneListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 40 // 좌우 패딩 제외
        let height: CGFloat = 120 // MilestoneCardCell과 동일한 높이
        return CGSize(width: width, height: height)
    }
}
