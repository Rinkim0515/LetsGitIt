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
    func configure(with data: WeeklyData) {
        // 기존 뷰들 제거
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // 새로운 스탯 뷰들 추가
        let statsData = [
            ("금주 이슈", data.summary),
            ("최대 연속", "\(data.currentStreak) Streak"),
            ("주간 코어 타임", data.weeklyTotalHours),
            ("코어 타임", data.coreTimeSettings)
        ]
        
        for (index, (title, value)) in statsData.enumerated() {
            let statView = createStatView(title: title, value: value)
            stackView.addArrangedSubview(statView)
            
            // 마지막 항목이 아니면 구분선 추가
            if index < statsData.count - 1 {
                let separator = createSeparator()
                stackView.addArrangedSubview(separator)
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정 (배경 있음)
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
    
    private func createStatView(title: String, value: String) -> UIView {
        let statView = UIView()
        let titleLabel = UILabel()
        let valueLabel = UILabel()
        
        // 제목 라벨 설정
        titleLabel.text = title
        titleLabel.font = .pretendard(.regular, size: 16)
        titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        // 값 라벨 설정
        valueLabel.text = value
        valueLabel.font = .pretendard(.semiBold, size: 16)
        valueLabel.textColor = UIColor(named: "AccentColor") ?? .systemBlue
        valueLabel.textAlignment = .right
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // 뷰 계층 구성
        statView.addSubview(titleLabel)
        statView.addSubview(valueLabel)
        
        [titleLabel, valueLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 높이 고정
            statView.heightAnchor.constraint(equalToConstant: 56),
            
            // 제목 라벨 (좌측)
            titleLabel.leadingAnchor.constraint(equalTo: statView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: statView.centerYAnchor),
            
            // 값 라벨 (우측)
            valueLabel.trailingAnchor.constraint(equalTo: statView.trailingAnchor, constant: -20),
            valueLabel.centerYAnchor.constraint(equalTo: statView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12)
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
