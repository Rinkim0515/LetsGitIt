//
//  IssueCardCell.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import UIKit

final class IssueCardCell: UICollectionViewCell {
    
    static let identifier = "IssueCardCell"
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let numberLabel = UILabel()
    private let statusBadge = UIView()
    private let statusLabel = UILabel()
    private let authorLabel = UILabel()
    private let createdDateLabel = UILabel()
    private let labelsStackView = UIStackView()
    
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
        numberLabel.text = nil
        statusLabel.text = nil
        authorLabel.text = nil
        createdDateLabel.text = nil
        
        // 기존 라벨들 제거
        labelsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Public Methods
    func configure(title: String, number: Int, status: IssueStatus, author: String, createdDate: String, labels: [IssueLabel]) {
        titleLabel.text = title
        numberLabel.text = "#\(number)"
        statusLabel.text = status.displayText
        authorLabel.text = "by \(author)"
        createdDateLabel.text = createdDate
        
        // 상태 스타일 설정
        setupStatusStyle(for: status)
        
        // 라벨들 설정
        setupLabels(labels)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정
        containerView.backgroundColor = UIColor(named: "BackgroundColor1") ?? .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(named: "Separator")?.cgColor ?? UIColor.separator.cgColor
        
        // 제목 라벨
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        titleLabel.numberOfLines = 2
        
        // 이슈 번호 라벨
        numberLabel.font = .systemFont(ofSize: 14, weight: .medium)
        numberLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        
        // 상태 배지
        statusBadge.layer.cornerRadius = 8
        
        // 상태 라벨
        statusLabel.font = .systemFont(ofSize: 12, weight: .bold)
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        
        // 작성자 라벨
        authorLabel.font = .systemFont(ofSize: 12, weight: .medium)
        authorLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        
        // 생성일 라벨
        createdDateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        createdDateLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        
        // 라벨 스택뷰
        labelsStackView.axis = .horizontal
        labelsStackView.spacing = 6
        labelsStackView.alignment = .leading
        
        // 뷰 계층 구성
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(numberLabel)
        containerView.addSubview(statusBadge)
        containerView.addSubview(authorLabel)
        containerView.addSubview(createdDateLabel)
        containerView.addSubview(labelsStackView)
        
        statusBadge.addSubview(statusLabel)
    }
    
    private func setupConstraints() {
        [containerView, titleLabel, numberLabel, statusBadge, statusLabel,
         authorLabel, createdDateLabel, labelsStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // 이슈 번호 (좌측 상단)
            numberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            numberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            // 상태 배지 (우측 상단)
            statusBadge.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            statusBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statusBadge.widthAnchor.constraint(equalToConstant: 60),
            statusBadge.heightAnchor.constraint(equalToConstant: 24),
            
            statusLabel.centerXAnchor.constraint(equalTo: statusBadge.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusBadge.centerYAnchor),
            
            // 제목 (번호 아래)
            titleLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // 라벨 스택뷰 (제목 아래)
            labelsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            labelsStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            labelsStackView.heightAnchor.constraint(equalToConstant: 20),
            
            // 작성자 (하단 좌측)
            authorLabel.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            // 생성일 (하단 우측)
            createdDateLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            createdDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            createdDateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: authorLabel.trailingAnchor, constant: 8)
        ])
    }
    
    private func setupStatusStyle(for status: IssueStatus) {
        switch status {
        case .open:
            statusBadge.backgroundColor = .systemGreen
        case .closed:
            statusBadge.backgroundColor = .systemRed
        }
    }
    
    private func setupLabels(_ labels: [IssueLabel]) {
        for label in labels.prefix(3) { // 최대 3개까지만 표시
            let labelView = createLabelView(label)
            labelsStackView.addArrangedSubview(labelView)
        }
        
        // 라벨이 3개 이상이면 "+N" 표시
        if labels.count > 3 {
            let moreLabel = createMoreLabelView(count: labels.count - 3)
            labelsStackView.addArrangedSubview(moreLabel)
        }
    }
    
    private func createLabelView(_ label: IssueLabel) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(hex: label.color) ?? .systemGray
        container.layer.cornerRadius = 4
        
        let titleLabel = UILabel()
        titleLabel.text = label.name
        titleLabel.font = .systemFont(ofSize: 10, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        container.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -6),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2)
        ])
        
        return container
    }
    
    private func createMoreLabelView(count: Int) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemGray
        container.layer.cornerRadius = 4
        
        let titleLabel = UILabel()
        titleLabel.text = "+\(count)"
        titleLabel.font = .systemFont(ofSize: 10, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        container.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -6),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2),
            container.widthAnchor.constraint(greaterThanOrEqualToConstant: 24)
        ])
        
        return container
    }
}

// MARK: - Issue Data Models
struct IssueItem {
    let id: String
    let title: String
    let number: Int
    let status: IssueStatus
    let author: String
    let createdDate: String
    let labels: [IssueLabel]
}

struct IssueLabel {
    let name: String
    let color: String // hex color
}

enum IssueStatus {
    case open
    case closed
    
    var displayText: String {
        switch self {
        case .open: return "Open"
        case .closed: return "Closed"
        }
    }
}
