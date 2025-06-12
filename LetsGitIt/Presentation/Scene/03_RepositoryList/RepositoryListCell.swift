//
//  AllRepositoryCell.swift
//  LetsGitIt
//
//  Created by KimRin on 6/9/25.
//

import UIKit

final class RepositoryListCell: UITableViewCell, CellIdGenerator {
    // MARK: - UI Components
    private let containerView = UIView()
    private let folderIconImageView = UIImageView()
    private let repositoryNameLabel = UILabel()
    private let selectedBadge = UIView()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // 컨테이너 뷰
        containerView.backgroundColor = UIColor(named: "CardBackground") ?? .systemGray6
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        
        // 폴더 아이콘
        folderIconImageView.contentMode = .scaleAspectFit
        folderIconImageView.tintColor = .systemGray2
        
        // 레포지토리 이름
        repositoryNameLabel.font = .pretendard(.regular, size: 16)
        repositoryNameLabel.textColor = .white
        repositoryNameLabel.numberOfLines = 1
        
        // 선택된 레포지토리 배지
        selectedBadge.backgroundColor = .systemBlue
        selectedBadge.layer.cornerRadius = 4
        selectedBadge.isHidden = true
        
        // 뷰 계층 구성
        contentView.addSubview(containerView)
        containerView.addSubview(folderIconImageView)
        containerView.addSubview(repositoryNameLabel)
        containerView.addSubview(selectedBadge)
    }
    
    private func setupConstraints() {
        [containerView, folderIconImageView, repositoryNameLabel, selectedBadge].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너 뷰
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            // 폴더 아이콘
            folderIconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            folderIconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            folderIconImageView.widthAnchor.constraint(equalToConstant: 24),
            folderIconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // 선택된 레포지토리 배지
            selectedBadge.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            selectedBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            selectedBadge.widthAnchor.constraint(equalToConstant: 8),
            selectedBadge.heightAnchor.constraint(equalToConstant: 8),
            
            // 레포지토리 이름
            repositoryNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            repositoryNameLabel.leadingAnchor.constraint(equalTo: folderIconImageView.trailingAnchor, constant: 12),
            repositoryNameLabel.trailingAnchor.constraint(equalTo: selectedBadge.leadingAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configure
    func configure(with repository: GitHubRepository, isSelectedRepository: Bool) {
        // 선택된 레포지토리 여부에 따른 아이콘과 색상 설정
        if isSelectedRepository {
            folderIconImageView.image = UIImage(systemName: "folder.fill")
            folderIconImageView.tintColor = .systemBlue
            selectedBadge.isHidden = false
            repositoryNameLabel.textColor = .systemBlue
        } else {
            folderIconImageView.image = UIImage(systemName: "folder")
            folderIconImageView.tintColor = .systemGray2
            selectedBadge.isHidden = true
            repositoryNameLabel.textColor = .white
        }
        
        // 레포지토리 이름
        repositoryNameLabel.text = repository.name
    }
}
