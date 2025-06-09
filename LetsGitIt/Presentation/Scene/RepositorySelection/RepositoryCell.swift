//
//  RepositoryCell.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class RepositoryCell: UITableViewCell, CellIdGenerator {
    // MARK: - UI Components
    private let containerView = UIView()
    private let checkboxView = UIView()
    private let checkboxIcon = UIImageView()
    private let folderIcon = UIImageView()
    private let repositoryNameLabel = UILabel()
    
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
        repositoryNameLabel.text = nil
        updateCheckbox(isSelected: false)
    }
    
    // MARK: - Public Methods
    func configure(with repository: GitHubRepository, isSelected: Bool) {
        repositoryNameLabel.text = repository.name
        updateCheckbox(isSelected: isSelected)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // 컨테이너 설정
        containerView.backgroundColor = .clear
        
        // 체크박스 뷰 설정
        checkboxView.backgroundColor = .clear
        checkboxView.layer.cornerRadius = 12
        checkboxView.layer.borderWidth = 2
        checkboxView.layer.borderColor = UIColor.systemGray3.cgColor
        
        // 체크박스 아이콘
        checkboxIcon.image = UIImage(systemName: "checkmark")
        checkboxIcon.tintColor = .white
        checkboxIcon.contentMode = .scaleAspectFit
        checkboxIcon.isHidden = true
        
        // 폴더 아이콘
        folderIcon.image = UIImage(systemName: "folder.fill")
        folderIcon.tintColor = UIColor(named: "SecondaryText") ?? .systemGray
        folderIcon.contentMode = .scaleAspectFit
        
        // 리포지토리 이름 라벨
        repositoryNameLabel.font = .pretendard(.regular, size: 16)
        repositoryNameLabel.textColor = .white
        repositoryNameLabel.numberOfLines = 1
        
        // 뷰 계층 구성
        contentView.addSubview(containerView)
        containerView.addSubview(checkboxView)
        containerView.addSubview(folderIcon)
        containerView.addSubview(repositoryNameLabel)
        checkboxView.addSubview(checkboxIcon)
    }
    
    private func setupConstraints() {
        [containerView, checkboxView, checkboxIcon, folderIcon, repositoryNameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // 체크박스 뷰 (좌측)
            checkboxView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            checkboxView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkboxView.widthAnchor.constraint(equalToConstant: 24),
            checkboxView.heightAnchor.constraint(equalToConstant: 24),
            
            // 체크박스 아이콘
            checkboxIcon.centerXAnchor.constraint(equalTo: checkboxView.centerXAnchor),
            checkboxIcon.centerYAnchor.constraint(equalTo: checkboxView.centerYAnchor),
            checkboxIcon.widthAnchor.constraint(equalToConstant: 14),
            checkboxIcon.heightAnchor.constraint(equalToConstant: 14),
            
            // 폴더 아이콘 (체크박스 다음)
            folderIcon.leadingAnchor.constraint(equalTo: checkboxView.trailingAnchor, constant: 16),
            folderIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            folderIcon.widthAnchor.constraint(equalToConstant: 20),
            folderIcon.heightAnchor.constraint(equalToConstant: 20),
            
            // 리포지토리 이름 (폴더 아이콘 다음)
            repositoryNameLabel.leadingAnchor.constraint(equalTo: folderIcon.trailingAnchor, constant: 12),
            repositoryNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            repositoryNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func updateCheckbox(isSelected: Bool) {
        if isSelected {
            // 선택됨: 파란색 배경 + 체크 아이콘
            checkboxView.backgroundColor = .systemBlue
            checkboxView.layer.borderColor = UIColor.systemBlue.cgColor
            checkboxIcon.isHidden = false
        } else {
            // 선택 안됨: 투명 배경 + 회색 테두리
            checkboxView.backgroundColor = .clear
            checkboxView.layer.borderColor = UIColor.systemGray3.cgColor
            checkboxIcon.isHidden = true
        }
    }
}
