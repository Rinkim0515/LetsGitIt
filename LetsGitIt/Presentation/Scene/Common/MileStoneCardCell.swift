//
//  MileStoneCardCell.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

// Common/Components/MilestoneCardCell.swift
import UIKit

final class MilestoneCardCell: UICollectionViewCell, CellIdGenerator {
    // MARK: - UI Components
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let ddayLabel = UILabel()
    private let ddayContainerView = UIView()
    private let descriptionLabel = UILabel()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        ddayLabel.text = nil
    }
    
    // MARK: - Public Methods
    func configure(title: String, description: String, tag: String, tagColor: UIColor, dday: String, ddayType: DDayType, progress: Double) {
        titleLabel.text = title
        descriptionLabel.text = description
        ddayLabel.text = dday
        
        
        
        // D-Day 스타일 설정
        setupDDayStyle(for: ddayType)
        
        // 프로그레스 바 설정
        updateProgress(progress)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정
        containerView.backgroundColor = UIColor(named: "BackgroundColor1") ?? .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        
        // 제목 라벨
        titleLabel.font = .pretendard(.semiBold, size: 16)
        titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        titleLabel.numberOfLines = 1
        
        // D-Day 컨테이너
        ddayContainerView.layer.cornerRadius = 8
        ddayContainerView.layer.borderWidth = 1
        ddayContainerView.backgroundColor = .clear
        
        // D-Day 라벨
        ddayLabel.font = .pretendard(.semiBold, size: 12)
        ddayLabel.textAlignment = .center
        
        // 설명 라벨
        descriptionLabel.font = .pretendard(.regular, size: 14)
        descriptionLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        descriptionLabel.numberOfLines = 2
        
        // 프로그레스 바 배경
        progressBar.backgroundColor = UIColor(named: "Disable") ?? .systemGray5
        progressBar.layer.cornerRadius = 2
        
        // 프로그레스 인디케이터
        progressIndicator.layer.cornerRadius = 2
        progressIndicator.backgroundColor = .systemBlue
        
        // 뷰 계층 구성
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(ddayContainerView)
        containerView.addSubview(progressBar)
        containerView.addSubview(descriptionLabel)
        ddayContainerView.addSubview(ddayLabel)
        progressBar.addSubview(progressIndicator)
    }
    
    private func setupConstraints() {
        [containerView, titleLabel, ddayContainerView, ddayLabel, progressBar,
         progressIndicator, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // 제목 (좌측)
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: ddayContainerView.leadingAnchor, constant: -12),
            
            // D-Day (우측 상단)
            ddayContainerView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            ddayContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            ddayContainerView.widthAnchor.constraint(equalToConstant: 40),
            ddayContainerView.heightAnchor.constraint(equalToConstant: 24),
            
            ddayLabel.centerXAnchor.constraint(equalTo: ddayContainerView.centerXAnchor),
            ddayLabel.centerYAnchor.constraint(equalTo: ddayContainerView.centerYAnchor),
            

            

            
            // 설명 (프로그레스바 아래)
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            // 프로그레스 바 (제목 아래)
            
            progressBar.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            progressIndicator.topAnchor.constraint(equalTo: progressBar.topAnchor),
            progressIndicator.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            progressIndicator.bottomAnchor.constraint(equalTo: progressBar.bottomAnchor),
            // width는 updateProgress에서 설정
            
        ])
    }
    
    private func setupDDayStyle(for ddayType: DDayType) {
        let color: UIColor
        switch ddayType {
        case .overdue:
            color = .systemRed
            ddayContainerView.layer.borderColor = color.cgColor
            ddayLabel.textColor = color
            progressIndicator.backgroundColor = color  // 프로그레스 바도 같은 색상
        case .upcoming:
            color = .systemGray
            ddayContainerView.layer.borderColor = color.cgColor
            ddayLabel.textColor = color
            progressIndicator.backgroundColor = color  // 프로그레스 바도 같은 색상
        }
    }
    
    private func updateProgress(_ progress: Double) {
        let clampedProgress = max(0.0, min(1.0, progress))
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 기존 width constraint 제거
            self.progressIndicator.constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    constraint.isActive = false
                }
            }
            
            let progressWidth = self.progressBar.frame.width * clampedProgress
            self.progressIndicator.widthAnchor.constraint(equalToConstant: max(0, progressWidth)).isActive = true
            
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Enums
enum DDayType {
    case overdue    // D+숫자 (빨간색)
    case upcoming   // D-숫자 (회색)
}

// MARK: - 사용 예시
/*
 사용법:
 
 cell.configure(
     title: "마일스톤 제목",
     description: "마일스톤 내용마일스톤 내용마일스톤 내용마일스톤 내용",
     tag: "Mobile App",
     tagColor: .systemPink,
     dday: "D+3",
     ddayType: .overdue,
     progress: 0.7
 )
 */
