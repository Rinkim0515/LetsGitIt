//
//  RecordStatsView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class RecordStatsView: UIView {
    
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
    func configure(with data: RecordStatsData) {
        // 기존 뷰들 제거
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // 새로운 기록 뷰들 추가
        for (index, record) in data.records.enumerated() {
            let recordView = createRecordView(text: record)
            stackView.addArrangedSubview(recordView)
            
            // 마지막 항목이 아니면 구분선 추가
            if index < data.records.count - 1 {
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
    
    private func createRecordView(text: String) -> UIView {
        let recordView = UIView()
        
        // 텍스트를 : 기준으로 분리 (있는 경우)
        let components = text.components(separatedBy: ": ")
        
        if components.count == 2 {
            // 제목: 값 형태
            let titleLabel = UILabel()
            let valueLabel = UILabel()
            
            // 제목 라벨 설정
            titleLabel.text = components[0]
            titleLabel.font = .pretendard(.regular, size: 16)
            titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
            titleLabel.setContentHuggingPriority(.required, for: .horizontal)
            
            // 값 라벨 설정
            valueLabel.text = components[1]
            valueLabel.font = .pretendard(.semiBold, size: 16)
            valueLabel.textColor = UIColor(named: "AccentColor") ?? .systemBlue
            valueLabel.textAlignment = .right
            valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            // 뷰 계층 구성
            recordView.addSubview(titleLabel)
            recordView.addSubview(valueLabel)
            
            [titleLabel, valueLabel].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
            NSLayoutConstraint.activate([
                // 높이 고정
                recordView.heightAnchor.constraint(equalToConstant: 56),
                
                // 제목 라벨 (좌측)
                titleLabel.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 20),
                titleLabel.centerYAnchor.constraint(equalTo: recordView.centerYAnchor),
                
                // 값 라벨 (우측)
                valueLabel.trailingAnchor.constraint(equalTo: recordView.trailingAnchor, constant: -20),
                valueLabel.centerYAnchor.constraint(equalTo: recordView.centerYAnchor),
                valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12)
            ])
            
        } else {
            // 단순 텍스트 형태
            let label = UILabel()
            
            // 라벨 설정
            label.text = text
            label.font = .pretendard(.regular, size: 16)
            label.textColor = UIColor(named: "PrimaryText") ?? .label
            label.numberOfLines = 1
            
            // 뷰 계층 구성
            recordView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                // 높이 고정
                recordView.heightAnchor.constraint(equalToConstant: 56),
                
                // 라벨 위치
                label.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: recordView.trailingAnchor, constant: -20),
                label.centerYAnchor.constraint(equalTo: recordView.centerYAnchor)
            ])
        }
        
        return recordView
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "Separator") ?? .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return separator
    }
}
