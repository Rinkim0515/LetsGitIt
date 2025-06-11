//
//  MilestoneNameCell.swift
//  LetsGitIt
//
//  Created by KimRin on 6/11/25.
//

import UIKit

final class MilestoneNameCell: UICollectionViewCell, CellIdGenerator {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let titleLabel = UILabel()
    
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
        updateSelection(false)
    }
    
    // MARK: - Public Methods
    func configure(name: String, isSelected: Bool) {
        titleLabel.text = name
        updateSelection(isSelected)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정
        containerView.layer.cornerRadius = 18
        containerView.layer.borderWidth = 1.5
        
        // 제목 라벨 설정
        titleLabel.font = .pretendard(.semiBold, size: 14)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        
        // 뷰 계층 구성
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        [containerView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너 (셀 전체)
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // 제목 라벨
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }
    
    private func updateSelection(_ isSelected: Bool) {
        if isSelected {
            // 선택된 상태: 파란색 배경 + 흰색 텍스트
            containerView.backgroundColor = .systemBlue
            containerView.layer.borderColor = UIColor.systemBlue.cgColor
            titleLabel.textColor = .white
        } else {
            // 선택 안된 상태: 투명 배경 + 회색 테두리 + 회색 텍스트
            containerView.backgroundColor = .clear
            containerView.layer.borderColor = UIColor.systemGray3.cgColor
            titleLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        }
    }
}
