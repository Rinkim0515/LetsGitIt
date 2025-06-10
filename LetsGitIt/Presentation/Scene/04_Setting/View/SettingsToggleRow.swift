//
//  SettingsToggleRow.swift
//  LetsGitIt
//
//  Created by KimRin on 6/3/25.
//

import UIKit

final class SettingsToggleRow: UIView {
    
    private let titleLabel = UILabel()
    private let toggleSwitch = UISwitch()
    private let separatorView = UIView()
    
    private var onToggle: ((Bool) -> Void)?
    
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
    
    func configure(title: String, isOn: Bool, onToggle: @escaping (Bool) -> Void) {
        titleLabel.text = title
        toggleSwitch.isOn = isOn
        self.onToggle = onToggle
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        titleLabel.font = .pretendard(.regular, size: 16)
        titleLabel.textColor = .textPrimary
        
        toggleSwitch.onTintColor = .systemBlue
        toggleSwitch.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        
        separatorView.backgroundColor = .separator
        
        addSubview(titleLabel)
        addSubview(toggleSwitch)
        addSubview(separatorView)
    }
    
    private func setupConstraints() {
        [titleLabel, toggleSwitch, separatorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            toggleSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    @objc private func toggleChanged() {
        onToggle?(toggleSwitch.isOn)
    }
}
