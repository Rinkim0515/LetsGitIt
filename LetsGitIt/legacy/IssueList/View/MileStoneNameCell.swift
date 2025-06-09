//
//  MilestoneNameCell.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class MilestoneNameCell: UICollectionViewCell, CellIdGenerator {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let nameLabel = UILabel()
    
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
        nameLabel.text = nil
        updateAppearance(isSelected: false)
    }
    
    // MARK: - Public Methods
    func configure(name: String, isSelected: Bool) {
        nameLabel.text = name
        updateAppearance(isSelected: isSelected)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정
        containerView.layer.cornerRadius = 18
        containerView.layer.borderWidth = 1
        
        // 이름 라벨 설정
        nameLabel.font = .pretendard(.semiBold, size: 14)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
        
        // 뷰 계층 구성
        contentView.addSubview(containerView)
        containerView.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        [containerView, nameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // 이름 라벨
            nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -12)
        ])
    }
    
    private func updateAppearance(isSelected: Bool) {
        if isSelected {
            // 선택된 상태 - 하얀색 배경, 검은색 텍스트
            containerView.backgroundColor = .white
            containerView.layer.borderColor = UIColor.white.cgColor
            nameLabel.textColor = .black
        } else {
            // 선택되지 않은 상태 - 투명 배경, 회색 텍스트
            containerView.backgroundColor = .clear
            containerView.layer.borderColor = UIColor.systemGray3.cgColor
            nameLabel.textColor = .systemGray2
        }
    }
}
