//
//  CurrentStatsView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class CurrentStatsView: UIView {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let stackView = UIStackView()
    
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
    func configure(with data: CurrentStatsData) {
        // 기존 뷰들 제거
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // 새로운 스탯 뷰들 추가
        for (index, stat) in data.stats.enumerated() {
            let statView = createStatView(text: stat)
            stackView.addArrangedSubview(statView)
            
            // 마지막 항목이 아니면 구분선 추가
            if index < data.stats.count - 1 {
                let separator = createSeparator()
                stackView.addArrangedSubview(separator)
            }
        }
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
    
    private func createStatView(text: String) -> UIView {
        let statView = UIView()
        let label = UILabel()
        
        // 라벨 설정
        label.text = text
        label.font = .pretendard(.regular, size: 16)
        label.textColor = UIColor(named: "PrimaryText") ?? .label
        label.numberOfLines = 1
        
        // 뷰 계층 구성
        statView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 높이 고정
            statView.heightAnchor.constraint(equalToConstant: 56),
            
            // 라벨 위치
            label.leadingAnchor.constraint(equalTo: statView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: statView.trailingAnchor, constant: -20),
            label.centerYAnchor.constraint(equalTo: statView.centerYAnchor)
        ])
        
        return statView
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "Separator") ?? .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return separator
    }
}
