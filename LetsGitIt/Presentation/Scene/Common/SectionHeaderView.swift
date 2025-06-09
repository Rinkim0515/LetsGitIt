//
//  SectionHeaderView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import UIKit

final class SectionHeaderView: UIView {
    
    // MARK: - UI Components
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    
    
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
    func configure(title: String, showMoreButton: Bool = true) {
        titleLabel.text = title
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 제목 라벨 설정
        titleLabel.font = .pretendard(.semiBold, size: 20)
        titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        // 스택뷰 설정
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        
        // 뷰 계층 구성
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 스택뷰
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            // 최소 높이 보장
            heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
}
