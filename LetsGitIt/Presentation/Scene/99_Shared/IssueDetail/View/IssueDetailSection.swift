//
//  IssueDetailSection.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//


import UIKit

final class IssueDetailSection: UIView {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let stackView = UIStackView()
    
    // 각 정보 행들
    private let labelRow = InfoRowView()
    private let assigneeRow = InfoRowView()
    private let projectRow = InfoRowView()
    private let milestoneRow = InfoRowView()
    private let createdDateRow = InfoRowView()
    private let modifiedDateRow = InfoRowView()
    
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
    
    // MARK: - Public Methods
    func configure(with issue: GitHubIssue) {
        
        configure(
            labels: issue.labels.displayText, // ✅ extension 사용
            assignee: issue.assignee?.login,
            project: "PC Web Dev", // TODO: 실제 프로젝트 정보
            milestone: issue.milestone?.title,
            createdDate: issue.createdDateText,
            modifiedDate: issue.updatedDateText
        )
    }
    
    // ✅ 기존 방식 (호환성 유지) - 이제 labels가 String
    func configure(
        labels: String, // ✅ [String] → String 변경
        assignee: String?,
        project: String?,
        milestone: String?,
        createdDate: String,
        modifiedDate: String
    ) {
        // 라벨 설정
        if labels.isEmpty || labels == "없음" {
            labelRow.configure(title: "라벨", value: "없음", valueColor: .systemGray)
        } else {
            labelRow.configure(title: "라벨", value: labels, valueColor: .systemBlue)
        }
        
        // 담당자 설정
        assigneeRow.configure(
            title: "담당자",
            value: assignee ?? "담당자없음",
            valueColor: assignee != nil ? .label : .systemGray
        )
        
        // 프로젝트 설정
        projectRow.configure(
            title: "프로젝트",
            value: project ?? "PC Web Dev",
            valueColor: project != nil ? .systemPurple : .systemGray
        )
        
        // 마일스톤 설정
        milestoneRow.configure(
            title: "마일스톤",
            value: milestone ?? "Sprint 1",
            valueColor: milestone != nil ? .systemOrange : .systemGray
        )
        
        // 생성일 설정
        createdDateRow.configure(
            title: "생성일",
            value: createdDate,
            valueColor: UIColor(named: "SecondaryText") ?? .secondaryLabel
        )
        
        // 수정일 설정
        modifiedDateRow.configure(
            title: "수정일",
            value: modifiedDate,
            valueColor: UIColor(named: "SecondaryText") ?? .secondaryLabel
        )
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정
        containerView.backgroundColor = UIColor(named: "BackgroundColor1") ?? .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        
        // 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // 뷰 계층 구성
        addSubview(containerView)
        containerView.addSubview(stackView)
        
        // 각 행 추가 (6개 행)
        stackView.addArrangedSubview(labelRow)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(assigneeRow)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(projectRow)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(milestoneRow)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(createdDateRow)
        stackView.addArrangedSubview(createSeparator())
        stackView.addArrangedSubview(modifiedDateRow)
    }
    
    private func setupConstraints() {
        [containerView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 스택뷰
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "Separator") ?? .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return separator
    }
}


