//
//  FloatingFilterView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class FloatingFilterView: UIView {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let backgroundView = UIView()
    private let movingIndicator = UIView()
    
    private let allLabel = UILabel()
    private let openLabel = UILabel()
    private let closedLabel = UILabel()
    
    // MARK: - Properties
    private var currentFilter: IssueFilter = .all
    var onFilterChanged: ((IssueFilter) -> Void)?
    
    private let segmentWidth: CGFloat = 40
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupGestures()
        updateIndicatorPosition(animated: false)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        setupGestures()
        updateIndicatorPosition(animated: false)
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        
        // 배경 뷰 (전체 영역)
        backgroundView.backgroundColor = .clear
        
        // 움직이는 인디케이터 (선택된 영역 표시)
        movingIndicator.backgroundColor = .white
        movingIndicator.layer.cornerRadius = 16
        
        // 라벨들 설정
        setupLabels()
        
        // 뷰 계층 구성
        addSubview(containerView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(movingIndicator)
        containerView.addSubview(allLabel)
        containerView.addSubview(openLabel)
        containerView.addSubview(closedLabel)
    }
    
    private func setupLabels() {
        let labels = [allLabel, openLabel, closedLabel]
        let titles = ["All", "Open", "Closed"]
        
        for (index, label) in labels.enumerated() {
            label.text = titles[index]
            label.font = .pretendard(.semiBold, size: 12)
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
        }
        
        updateLabelColors()
    }
    
    private func setupConstraints() {
        [containerView, backgroundView, movingIndicator, allLabel, openLabel, closedLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 배경 뷰
            backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // 움직이는 인디케이터
            movingIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            movingIndicator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
            movingIndicator.widthAnchor.constraint(equalToConstant: 32),
            
            // All 라벨
            allLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            allLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            allLabel.widthAnchor.constraint(equalToConstant: segmentWidth),
            
            // Open 라벨
            openLabel.leadingAnchor.constraint(equalTo: allLabel.trailingAnchor),
            openLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            openLabel.widthAnchor.constraint(equalToConstant: segmentWidth),
            
            // Closed 라벨
            closedLabel.leadingAnchor.constraint(equalTo: openLabel.trailingAnchor),
            closedLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            closedLabel.widthAnchor.constraint(equalToConstant: segmentWidth)
        ])
    }
    
    private func setupGestures() {
        let allTap = UITapGestureRecognizer(target: self, action: #selector(allTapped))
        let openTap = UITapGestureRecognizer(target: self, action: #selector(openTapped))
        let closedTap = UITapGestureRecognizer(target: self, action: #selector(closedTapped))
        
        allLabel.addGestureRecognizer(allTap)
        openLabel.addGestureRecognizer(openTap)
        closedLabel.addGestureRecognizer(closedTap)
    }
    
    // MARK: - Actions
    @objc private func allTapped() {
        selectFilter(.all)
    }
    
    @objc private func openTapped() {
        selectFilter(.open)
    }
    
    @objc private func closedTapped() {
        selectFilter(.closed)
    }
    
    private func selectFilter(_ filter: IssueFilter) {
        guard currentFilter != filter else { return }
        
        currentFilter = filter
        updateIndicatorPosition(animated: true)
        updateLabelColors()
        onFilterChanged?(filter)
    }
    
    // MARK: - Private Methods
    private func updateIndicatorPosition(animated: Bool) {
        let targetX: CGFloat
        
        switch currentFilter {
        case .all:
            targetX = 4
        case .open:
            targetX = 4 + segmentWidth
        case .closed:
            targetX = 4 + segmentWidth * 2
        }
        
        // 기존 leading constraint 제거
        movingIndicator.constraints.forEach { constraint in
            if constraint.firstAttribute == .leading {
                constraint.isActive = false
            }
        }
        
        // 새로운 leading constraint 추가
        movingIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: targetX).isActive = true
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
    
    private func updateLabelColors() {
        let labels = [allLabel, openLabel, closedLabel]
        let filters: [IssueFilter] = [.all, .open, .closed]
        
        for (index, label) in labels.enumerated() {
            let isSelected = filters[index] == currentFilter
            label.textColor = isSelected ? .black : .white
        }
    }
    
    // MARK: - Public Methods
    func setFilter(_ filter: IssueFilter, animated: Bool = true) {
        currentFilter = filter
        updateIndicatorPosition(animated: animated)
        updateLabelColors()
    }
}
