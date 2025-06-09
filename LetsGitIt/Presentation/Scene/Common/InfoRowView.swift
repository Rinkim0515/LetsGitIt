//
//  InfoRowView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/9/25.
//

import UIKit

final class InfoRowView: UIView {
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
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
    
    func configure(title: String, value: String, valueColor: UIColor = .label) {
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.textColor = valueColor
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // 제목 라벨
        titleLabel.font = .pretendard(.regular, size: 16)
        titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        // 값 라벨
        valueLabel.font = .pretendard(.semiBold, size: 16)
        valueLabel.textAlignment = .right
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        addSubview(titleLabel)
        addSubview(valueLabel)
    }
    
    private func setupConstraints() {
        [titleLabel, valueLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 행 높이
            heightAnchor.constraint(equalToConstant: 56),
            
            // 제목 라벨 (좌측)
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // 값 라벨 (우측)
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12)
        ])
    }
}
