//
//  SettingsTableViewCell.swift
//  LetsGitIt
//
//  Created by KimRin on 6/3/25.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = "SettingsTableViewCell"
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let rightLabel = UILabel()
    private let disclosureImageView = UIImageView()
    private let separatorView = UIView()
    
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
        rightLabel.text = nil
        rightLabel.isHidden = true
        disclosureImageView.isHidden = true
    }
    
    // MARK: - Public Methods
    func configure(with item: SettingsItem) {
        titleLabel.text = item.title
        
        // 우측 텍스트 설정
        if let rightText = item.rightText {
            rightLabel.text = rightText
            rightLabel.isHidden = false
            disclosureImageView.isHidden = true
        } else {
            rightLabel.isHidden = true
            disclosureImageView.isHidden = !item.hasDisclosure
        }
        
        // 선택 스타일 설정
        selectionStyle = item.hasDisclosure ? .default : .none
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .backgroundColor2
        
        // 제목 라벨 설정
        titleLabel.font = .pretendard(.regular, size: 16)
        titleLabel.textColor = .textPrimary
        
        // 우측 라벨 설정 (버전 정보용)
        rightLabel.font = .pretendard(.regular, size: 16)
        rightLabel.textColor = .textSecondary
        rightLabel.textAlignment = .right
        rightLabel.isHidden = true
        
        // 화살표 이미지 설정
        disclosureImageView.image = UIImage(systemName: "chevron.right")
        disclosureImageView.tintColor = .textSecondary
        disclosureImageView.contentMode = .scaleAspectFit
        disclosureImageView.isHidden = true
        
        // 구분선 설정
        separatorView.backgroundColor = .separator
        
        // 뷰 계층 구성
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(disclosureImageView)
        contentView.addSubview(separatorView)
    }
    
    private func setupConstraints() {
        [titleLabel, rightLabel, disclosureImageView, separatorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 제목 라벨
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightLabel.leadingAnchor, constant: -8),
            
            // 우측 라벨 (버전 정보)
            rightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rightLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            // 화살표 이미지
            disclosureImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            disclosureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            disclosureImageView.widthAnchor.constraint(equalToConstant: 12),
            disclosureImageView.heightAnchor.constraint(equalToConstant: 12),
            
            // 구분선
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
