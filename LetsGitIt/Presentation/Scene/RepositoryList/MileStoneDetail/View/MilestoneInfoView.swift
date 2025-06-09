//
//  MilestoneInfoView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import UIKit

final class MilestoneInfoView: UIView {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let stackView = UIStackView()
    
    // 상단: Description
    private let descriptionLabel = UILabel()
    
    // 중간: 이슈 개수 + 진행률 + Due Date
    private let statsStackView = UIStackView()
    private let issueCountLabel = UILabel()
    private let progressLabel = UILabel()
    private let dueDateLabel = UILabel()
    
    // 하단: Progress Bar
    private let progressBarContainer = UIView()
    private let progressBar = UIView()
    private let progressIndicator = UIView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Public Methods
    func configure(with milestone: MilestoneItem) {
        // Description 설정
        descriptionLabel.text = milestone.description
        
        // 진행률 계산 (Mock 데이터)
        let openIssues = Int(Double(8) * (1.0 - milestone.progress)) // 총 8개 이슈 가정
        let closedIssues = 8 - openIssues
        let progressPercentage = Int(milestone.progress * 100)
        
        // 이슈 개수
        issueCountLabel.text = "이슈: \(openIssues) open / \(closedIssues) closed"
        
        // 진행률
        progressLabel.text = "\(progressPercentage)% 완료"
        
        // Due Date (D-day를 실제 날짜로 변환)
        if milestone.dday.contains("D-") {
            let daysLeft = milestone.dday.replacingOccurrences(of: "D-", with: "")
            if let days = Int(daysLeft) {
                let futureDate = Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                dueDateLabel.text = "Due by \(formatter.string(from: futureDate))"
            }
        } else if milestone.dday.contains("D+") {
            dueDateLabel.text = "기한 초과"
            dueDateLabel.textColor = .systemRed
        }
        
        // Progress Bar 업데이트
        updateProgressBar(progress: milestone.progress)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정
        containerView.backgroundColor = UIColor(named: "BackgroundColor1") ?? .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        
        // 메인 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // Description 라벨 설정
        descriptionLabel.font = .pretendard(.regular, size: 16)
        descriptionLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        // 통계 스택뷰 설정
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.alignment = .center
        statsStackView.spacing = 8
        
        // 이슈 개수 라벨
        issueCountLabel.font = .pretendard(.semiBold, size: 14)
        issueCountLabel.textColor = UIColor(named: "AccentColor") ?? .systemBlue
        issueCountLabel.textAlignment = .left
        
        // 진행률 라벨
        progressLabel.font = .pretendard(.semiBold, size: 14)
        progressLabel.textColor = UIColor(named: "AccentColor") ?? .systemBlue
        progressLabel.textAlignment = .center
        
        // Due Date 라벨
        dueDateLabel.font = .pretendard(.regular, size: 14)
        dueDateLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        dueDateLabel.textAlignment = .right
        
        // Progress Bar 컨테이너
        progressBarContainer.backgroundColor = .clear
        
        // Progress Bar 배경
        progressBar.backgroundColor = UIColor(named: "Disable") ?? .systemGray5
        progressBar.layer.cornerRadius = 4
        
        // Progress Bar 인디케이터
        progressIndicator.backgroundColor = .systemBlue
        progressIndicator.layer.cornerRadius = 4
        
        // 뷰 계층 구성
        addSubview(containerView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(statsStackView)
        stackView.addArrangedSubview(progressBarContainer)
        
        statsStackView.addArrangedSubview(issueCountLabel)
        statsStackView.addArrangedSubview(progressLabel)
        statsStackView.addArrangedSubview(dueDateLabel)
        
        progressBarContainer.addSubview(progressBar)
        progressBar.addSubview(progressIndicator)
    }
    
    private func setupConstraints() {
        [containerView, stackView, progressBarContainer, progressBar, progressIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 스택뷰
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            // Progress Bar 컨테이너
            progressBarContainer.heightAnchor.constraint(equalToConstant: 8),
            
            // Progress Bar 배경
            progressBar.topAnchor.constraint(equalTo: progressBarContainer.topAnchor),
            progressBar.leadingAnchor.constraint(equalTo: progressBarContainer.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: progressBarContainer.trailingAnchor),
            progressBar.bottomAnchor.constraint(equalTo: progressBarContainer.bottomAnchor),
            
            // Progress Bar 인디케이터
            progressIndicator.topAnchor.constraint(equalTo: progressBar.topAnchor),
            progressIndicator.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            progressIndicator.bottomAnchor.constraint(equalTo: progressBar.bottomAnchor),
            // width는 updateProgressBar에서 설정
        ])
    }
    
    private func updateProgressBar(progress: Double) {
        let clampedProgress = max(0.0, min(1.0, progress))
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 기존 width constraint 제거
            self.progressIndicator.constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    constraint.isActive = false
                }
            }
            
            // 새로운 width constraint 추가
            let progressWidth = self.progressBar.frame.width * clampedProgress
            self.progressIndicator.widthAnchor.constraint(equalToConstant: max(0, progressWidth)).isActive = true
            
            // 애니메이션으로 업데이트
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
}
