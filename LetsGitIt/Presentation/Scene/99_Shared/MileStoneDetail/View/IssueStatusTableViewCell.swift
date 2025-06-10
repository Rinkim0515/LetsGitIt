//
//  IssueStatusTableViewCell.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import UIKit

final class IssueStatusTableViewCell: UITableViewCell, CellIdGenerator {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let statusIconView = UIView()
    private let statusIconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let numberLabel = UILabel()
    private let authorLabel = UILabel()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        authorLabel.text = nil
        updateStatusIcon(isOpen: true) // 기본값
    }
    
    // MARK: - Public Methods
    func configure(with issue: GitHubIssue) {
        titleLabel.text = issue.title
        numberLabel.text = "#\(issue.number)"
        authorLabel.text = "by \(issue.author)"
        updateStatusIcon(isOpen: issue.isOpen)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // 컨테이너 설정
        containerView.backgroundColor = UIColor(named: "BackgroundColor1") ?? .secondarySystemBackground
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(named: "Separator")?.cgColor ?? UIColor.separator.cgColor
        
        // 상태 아이콘 뷰 설정
        statusIconView.layer.cornerRadius = 8
        statusIconView.backgroundColor = .systemGreen
        
        // 상태 아이콘 이미지뷰 설정
        statusIconImageView.contentMode = .scaleAspectFit
        statusIconImageView.tintColor = .white
        
        // 제목 라벨 설정
        titleLabel.font = .pretendard(.semiBold, size: 16)
        titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        
        // 이슈 번호 라벨 설정
        numberLabel.font = .pretendard(.regular, size: 14)
        numberLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        
        // 작성자 라벨 설정
        authorLabel.font = .pretendard(.regular, size: 12)
        authorLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        
        // 뷰 계층 구성
        contentView.addSubview(containerView)
        containerView.addSubview(statusIconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(numberLabel)
        containerView.addSubview(authorLabel)
        statusIconView.addSubview(statusIconImageView)
    }
    
    private func setupConstraints() {
        [containerView, statusIconView, statusIconImageView, titleLabel, numberLabel, authorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // 상태 아이콘 뷰 (좌측)
            statusIconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            statusIconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusIconView.widthAnchor.constraint(equalToConstant: 16),
            statusIconView.heightAnchor.constraint(equalToConstant: 16),
            
            // 상태 아이콘 이미지
            statusIconImageView.centerXAnchor.constraint(equalTo: statusIconView.centerXAnchor),
            statusIconImageView.centerYAnchor.constraint(equalTo: statusIconView.centerYAnchor),
            statusIconImageView.widthAnchor.constraint(equalToConstant: 10),
            statusIconImageView.heightAnchor.constraint(equalToConstant: 10),
            
            // 이슈 번호 (상단 우측)
            numberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            numberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // 제목 (상태 아이콘 옆)
            titleLabel.leadingAnchor.constraint(equalTo: statusIconView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: numberLabel.leadingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: statusIconView.centerYAnchor, constant: -6),
            
            // 작성자 (제목 아래)
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    private func updateStatusIcon(isOpen: Bool) {
        if isOpen {
            // Open 상태: 녹색 배경 + 동그라미 아이콘
            statusIconView.backgroundColor = .systemGreen
            statusIconImageView.image = UIImage(systemName: "circle")
        } else {
            // Closed 상태: 보라색 배경 + 체크마크 아이콘
            statusIconView.backgroundColor = .systemPurple
            statusIconImageView.image = UIImage(systemName: "checkmark")
        }
    }
}


