//
//  IssueCardCell.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import UIKit

final class IssueCardCell: UICollectionViewCell, CellIdGenerator {
    // MARK: - UI Components
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let numberLabel = UILabel()
    private let mileStoneLabel = UILabel()
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
    }
    
    // MARK: - Public Methods

    
    func configure(with issue: GitHubIssue) {
        titleLabel.text = issue.title
        numberLabel.text = issue.numberText // computed property 사용
        mileStoneLabel.text = issue.hasMilestone ?
            "마일스톤명: \(issue.milestoneText)" :
            "마일스톤이 없습니다."
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
        titleLabel.font = .pretendard(.semiBold, size: 16)
        titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        titleLabel.numberOfLines = 2
        
        // 이슈 번호 라벨
        numberLabel.font = .pretendard(.regular, size: 14)
        numberLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        
        mileStoneLabel.font = .pretendard(.semiBold, size: 14)
        mileStoneLabel.textColor = UIColor(named: "PrimaryText") ?? .secondaryLabel
        
        // 뷰 계층 구성
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(numberLabel)
        containerView.addSubview(mileStoneLabel)
        
    }
    
    private func setupConstraints() {
        [containerView,
         titleLabel,
         numberLabel,
          mileStoneLabel].forEach {
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
            
            // 제목 (번호 아래)
            titleLabel.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor)
            ,
            titleLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 10),
            
            
            // 작성자 (하단 좌측)
            mileStoneLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            mileStoneLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor),
        ])
    }
    
    

}

