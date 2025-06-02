//
//  SectionHeaderView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//


import UIKit

final class UserProfileHeaderView: UIView {
    
    // MARK: - UI Components
    private let containerView = UIView()
    
    // 좌측 프로필 섹션
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let rankingLabel = UILabel()
    
    // 우측 통계 섹션
    private let statsStackView = UIStackView()
    private let completedMilestoneLabel = UILabel()
    private let savedMilestoneLabel = UILabel()
    
    // 하단 상태 배지
    private let statusBadgeView = UIView()
    private let statusIconImageView = UIImageView()
    private let statusLabel = UILabel()
    
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
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if statusBadgeView.layer.sublayers?.first(where: { $0.name == "GradientLayer" }) == nil {
                statusBadgeView.applyBrandGradient(direction: .horizontal)
                if let gradientLayer = statusBadgeView.layer.sublayers?.first(where: { $0.name == "GradientLayer" }) {
                    gradientLayer.cornerRadius = 16
                    gradientLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                }
            }
    }
    
    // MARK: - Public Methods
    func configure(name: String, subtitle: String, completedCount: Int, savedCount: Int, statusText: String) {
        nameLabel.text = name
        rankingLabel.text = "랭킹: \(subtitle)등"
        completedMilestoneLabel.text = "완료 마일스톤 \(completedCount)개"
        savedMilestoneLabel.text = "저장 마일스톤 \(savedCount.formatted())개"
        statusLabel.text = statusText
    }
    
    func setAvatarImage(_ image: UIImage?) {
        avatarImageView.image = image
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 뷰 설정
        containerView.backgroundColor = .cardBackground
        
        
        // 아바타 이미지뷰 설정
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.backgroundColor = .systemBlue
        
        let diamondImage = createDiamondImage() // 뱃지 이미지
        avatarImageView.image = diamondImage
        
        
        nameLabel.font = .pretendard(.semiBold, size: 20)
        nameLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        
        // 부제목 라벨 설정
        rankingLabel.font = .pretendard(.regular, size: 14)
        rankingLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        
        // 통계 스택뷰 설정
        statsStackView.axis = .vertical
        statsStackView.spacing = 4
        statsStackView.alignment = .trailing
        
        // 완료 마일스톤 라벨
        completedMilestoneLabel.font = .pretendard(.regular, size: 12)
        completedMilestoneLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        completedMilestoneLabel.textAlignment = .right
        
        // 저장 마일스톤 라벨
        savedMilestoneLabel.font = .pretendard(.regular, size: 12)
        savedMilestoneLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        savedMilestoneLabel.textAlignment = .right
        
        
        
        // 상태 아이콘 설정
        statusIconImageView.image = UIImage(systemName: "bolt.fill")
        statusIconImageView.tintColor = .white
        statusIconImageView.contentMode = .scaleAspectFit
        
        
        // 상태 라벨 설정
        statusLabel.font = .pretendard(.regular, size: 14)
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        
        // 뷰 계층 구성
        addSubview(containerView)
        addSubview(statusBadgeView)
        
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(rankingLabel)
        containerView.addSubview(statsStackView)
        
        statsStackView.addArrangedSubview(completedMilestoneLabel)
        statsStackView.addArrangedSubview(savedMilestoneLabel)
        
        statusBadgeView.addSubview(statusIconImageView)
        statusBadgeView.addSubview(statusLabel)
    }
    
    private func setupConstraints() {
        [containerView, statusBadgeView, avatarImageView, nameLabel, rankingLabel,
         statsStackView, statusIconImageView, statusLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너 뷰
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 80),
            
            // 아바타 이미지
            avatarImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // 이름 라벨
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            
            // 부제목 라벨
            rankingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            rankingLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // 통계 스택뷰
            statsStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statsStackView.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 12),
            
            // 상태 배지
            statusBadgeView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12),
            statusBadgeView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            statusBadgeView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            statusBadgeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            statusBadgeView.heightAnchor.constraint(equalToConstant: 44),
            
            // 상태 아이콘
            statusIconImageView.centerYAnchor.constraint(equalTo: statusBadgeView.centerYAnchor),
            statusIconImageView.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -5),
            statusIconImageView.widthAnchor.constraint(equalToConstant: 16),
            statusIconImageView.heightAnchor.constraint(equalToConstant: 16),
            
            // 상태 라벨
            statusLabel.centerYAnchor.constraint(equalTo: statusBadgeView.centerYAnchor),
            statusLabel.centerXAnchor.constraint(equalTo: statusBadgeView.centerXAnchor)
        ])
    }

    
    private func createDiamondImage() -> UIImage? {
        return UIImage(named: "suit.diamond")
    }
}

