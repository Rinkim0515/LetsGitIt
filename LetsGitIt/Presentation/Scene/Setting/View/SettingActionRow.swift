//
//  SettingActionRow.swift
//  LetsGitIt
//
//  Created by KimRin on 6/3/25.
//

import UIKit

final class SettingsActionRow: UIView {
    
    private let titleLabel = UILabel()
    private let rightLabel = UILabel()
    private let separatorView = UIView()
    
    private var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        setupGesture()
    }
    
    func configure(title: String, rightText: String, onTap: @escaping () -> Void) {
        titleLabel.text = title
        rightLabel.text = rightText
        self.onTap = onTap
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        titleLabel.font = .pretendard(.regular, size: 16)
        titleLabel.textColor = .textPrimary
        
        rightLabel.font = .pretendard(.regular, size: 16)
        rightLabel.textColor = .textSecondary
        rightLabel.textAlignment = .right
        
        separatorView.backgroundColor = .separator
        
        addSubview(titleLabel)
        addSubview(rightLabel)
        addSubview(separatorView)
    }
    
    private func setupConstraints() {
        [titleLabel, rightLabel, separatorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}
