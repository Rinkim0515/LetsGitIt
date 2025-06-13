//
//  EmptyStateCell.swift
//  LetsGitIt
//
//  Created by KimRin on 6/13/25.
//

import UIKit

final class EmptyStateCell: UICollectionViewCell, CellIdGenerator {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let messageLabel = UILabel()
    
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
        messageLabel.text = nil
    }
    
    // MARK: - Public Methods
    func configure(message: String) {
        messageLabel.text = message
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정 (기존 카드 스타일과 동일)
        containerView.backgroundColor = UIColor(named: "BackgroundColor1") ?? .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(named: "Separator")?.cgColor ?? UIColor.separator.cgColor
        
        // 메시지 라벨
        messageLabel.font = .pretendard(.regular, size: 16)
        messageLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        // 뷰 계층 구성
        contentView.addSubview(containerView)
        containerView.addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        [containerView, messageLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너 (셀 전체)
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // 메시지 라벨 (컨테이너 중앙)
            messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -20)
        ])
    }
}
