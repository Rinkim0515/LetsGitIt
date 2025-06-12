//
//  CustomAlert.swift
//  LetsGitIt
//
//  Created by Developer on 2025.06.09.
//

import UIKit

// MARK: - Alert Action Type
enum CustomAlertActionType {
    case single(title: String)
    case dual(secondary: String, primary: String)
}

// MARK: - Custom Alert (Closure 기반)
final class CustomAlert: UIView {
    
    // MARK: - UI Components
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let buttonStackView = UIStackView()
    
    // MARK: - Properties
    private var primaryAction: (() -> Void)?
    private var secondaryAction: (() -> Void)?
    private var actionType: CustomAlertActionType = .single(title: "확인")
    
    // MARK: - Initializers
    private override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        // 배경 뷰 (반투명 검정)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        backgroundView.alpha = 0
        
        // 컨테이너 뷰 (알럿 박스)
        containerView.backgroundColor = UIColor(named: "BackgroundColor1") ?? .secondarySystemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // 제목 라벨
        titleLabel.font = .pretendard(.semiBold, size: 18)
        titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        // 메시지 라벨
        messageLabel.font = .pretendard(.regular, size: 14)
        messageLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        // 버튼 스택뷰
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 12
        
        // 뷰 계층 구성
        addSubview(backgroundView)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(buttonStackView)
        
        // 배경 탭 제스처
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        [backgroundView, containerView, titleLabel, messageLabel, buttonStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 배경 뷰 (전체 화면)
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 컨테이너 뷰 (중앙 정렬)
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -40),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            
            // 제목
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // 메시지
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // 버튼 스택뷰
            buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Public Methods
    func configure(
        title: String,
        message: String,
        actionType: CustomAlertActionType,
        primaryAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        titleLabel.text = title
        messageLabel.text = message
        self.actionType = actionType
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        setupButtons()
    }
    
    func show(on vc: UIViewController) {
        guard let window = vc.view.window else { return }
        
        frame = window.bounds
        window.addSubview(self)
        
        // 애니메이션으로 표시
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.backgroundView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.backgroundView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Private Methods
    private func setupButtons() {
        // 기존 버튼들 제거
        buttonStackView.arrangedSubviews.forEach { view in
            buttonStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        switch actionType {
        case .single(let title):
            let confirmButton = createButton(title: title, style: .primary)
            confirmButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
            buttonStackView.addArrangedSubview(confirmButton)
            
        case .dual(let secondaryTitle, let primaryTitle):
            let cancelButton = createButton(title: secondaryTitle, style: .secondary)
            let confirmButton = createButton(title: primaryTitle, style: .primary)
            
            cancelButton.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)
            confirmButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
            
            buttonStackView.addArrangedSubview(cancelButton)
            buttonStackView.addArrangedSubview(confirmButton)
        }
    }
    
    private func createButton(title: String, style: ButtonStyle) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .pretendard(.semiBold, size: 16)
        button.layer.cornerRadius = 8
        
        switch style {
        case .primary:
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
        case .secondary:
            button.backgroundColor = UIColor(named: "SubColor2") ?? .systemGray5
            button.setTitleColor(UIColor(named: "PrimaryText") ?? .label, for: .normal)
        }
        
        return button
    }
    
    // MARK: - Actions
    @objc private func primaryButtonTapped() {
        primaryAction?()  // 👈 Closure 실행
        dismiss()
    }
    
    @objc private func secondaryButtonTapped() {
        secondaryAction?()  // 👈 Closure 실행
        dismiss()
    }
    
    @objc private func backgroundTapped() {
        dismiss()
    }
    
    // MARK: - Button Style
    private enum ButtonStyle {
        case primary
        case secondary
    }
}

// MARK: - Builder
extension CustomAlert {
    static func builder() -> CustomAlertBuilder {
        return CustomAlertBuilder()
    }
}

// MARK: - Builder Class (Closure 기반)
final class CustomAlertBuilder {
    
    private var title: String = ""
    private var message: String = ""
    private var actionType: CustomAlertActionType = .single(title: "확인")
    private var primaryAction: (() -> Void)?
    private var secondaryAction: (() -> Void)?
    
    func title(_ title: String) -> CustomAlertBuilder {
        self.title = title
        return self
    }
    
    func message(_ message: String) -> CustomAlertBuilder {
        self.message = message
        return self
    }
    
    func singleAction(title: String = "확인") -> CustomAlertBuilder {
        self.actionType = .single(title: title)
        return self
    }
    
    func dualAction(secondary: String = "취소", primary: String = "확인") -> CustomAlertBuilder {
        self.actionType = .dual(secondary: secondary, primary: primary)
        return self
    }
    
    func primaryAction(_ action: @escaping () -> Void) -> CustomAlertBuilder {
        self.primaryAction = action
        return self
    }
    
    func secondaryAction(_ action: @escaping () -> Void) -> CustomAlertBuilder {
        self.secondaryAction = action
        return self
    }
    
    func build() -> CustomAlert {
        let alert = CustomAlert()
        alert.configure(
            title: title,
            message: message,
            actionType: actionType,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction
        )
        return alert
    }
}
