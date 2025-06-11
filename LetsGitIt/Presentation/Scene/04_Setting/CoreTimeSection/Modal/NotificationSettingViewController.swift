//
//  NotificationSettingViewController.swift
//  LetsGitIt
//
//  Created by Developer on 2025.06.09.
//

import UIKit

final class NotificationSettingViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let headerView = TitleHeaderView()
    private let optionStackView = UIStackView()
    private let updateButton = UIButton(type: .system)
    
    // MARK: - Properties
    private let notificationOptions = [
        NotificationOption.none,
        NotificationOption.fiveMinutes,
        NotificationOption.tenMinutes,
        NotificationOption.thirtyMinutes,
        NotificationOption.sixtyMinutes
    ]
    
    private var selectedOption: NotificationOption
    private var optionRows: [NotificationOptionRow] = []
    var onSelectionChanged: ((NotificationOption) -> Void)?
    
    // MARK: - Initialization
    init(selectedOption: NotificationOption = .none) {
        self.selectedOption = selectedOption
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor1") ?? .systemBackground
        
        // ScrollView 설정
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        // StackView 설정
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        
        // Header 설정
        headerView.configure(title: "시작 전 알림", showMoreButton: false)
        
        // 옵션 스택뷰
        optionStackView.axis = .vertical
        optionStackView.spacing = 0
        optionStackView.alignment = .fill
        
        // 알림 옵션 행들 생성
        for option in notificationOptions {
            let optionRow = NotificationOptionRow()
            let isSelected = option == selectedOption
            
            optionRow.configure(option: option, isSelected: isSelected) { [weak self] in
                self?.optionTapped(option: option)
            }
            
            optionRows.append(optionRow)
            optionStackView.addArrangedSubview(optionRow)
        }
        
        // 업데이트 버튼 설정
        updateButton.setTitle("업데이트 하기", for: .normal)
        updateButton.titleLabel?.font = .pretendard(.semiBold, size: 16)
        updateButton.backgroundColor = .systemBlue
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.layer.cornerRadius = 12
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        
        // 뷰 계층 구성
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(optionStackView)
        stackView.addArrangedSubview(updateButton)
    }
    
    private func setupConstraints() {
        [scrollView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // StackView
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -34),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 업데이트 버튼
            updateButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            updateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    private func optionTapped(option: NotificationOption) {
        selectedOption = option
        updateOptionRows()
    }
    
    private func updateOptionRows() {
        for (index, row) in optionRows.enumerated() {
            let option = notificationOptions[index]
            row.updateSelection(option == selectedOption)
        }
    }
    
    @objc private func updateButtonTapped() {
        onSelectionChanged?(selectedOption)
        coordinator?.dismissModal()
    }
}

// MARK: - NotificationOption
enum NotificationOption: CaseIterable {
    case none
    case fiveMinutes
    case tenMinutes
    case thirtyMinutes
    case sixtyMinutes
    
    var displayText: String {
        switch self {
        case .none: return "없음"
        case .fiveMinutes: return "5분 전"
        case .tenMinutes: return "10분 전"
        case .thirtyMinutes: return "30분 전"
        case .sixtyMinutes: return "60분 전"
        }
    }
}

// MARK: - NotificationOptionRow
final class NotificationOptionRow: UIView {
    
    private let radioButtonView = UIView()
    private let innerDotView = UIView()
    private let titleLabel = UILabel()
    private var onTapped: (() -> Void)?
    
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
    
    func configure(option: NotificationOption, isSelected: Bool, onTapped: @escaping () -> Void) {
        titleLabel.text = option.displayText
        self.onTapped = onTapped
        updateSelection(isSelected)
    }
    
    func updateSelection(_ isSelected: Bool) {
        if isSelected {
            radioButtonView.backgroundColor = .clear
            radioButtonView.layer.borderColor = UIColor.systemBlue.cgColor
            radioButtonView.layer.borderWidth = 2
            innerDotView.isHidden = false
            innerDotView.backgroundColor = .systemBlue
        } else {
            radioButtonView.backgroundColor = .clear
            radioButtonView.layer.borderColor = UIColor.systemGray3.cgColor
            radioButtonView.layer.borderWidth = 2
            innerDotView.isHidden = true
        }
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // 라디오 버튼 (원형)
        radioButtonView.layer.cornerRadius = 12
        radioButtonView.layer.borderWidth = 2
        radioButtonView.layer.borderColor = UIColor.systemGray3.cgColor
        
        // 내부 점
        innerDotView.backgroundColor = .systemBlue
        innerDotView.layer.cornerRadius = 6
        innerDotView.isHidden = true
        
        // 제목 라벨
        titleLabel.font = .pretendard(.regular, size: 16)
        titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        
        // 탭 제스처
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
        
        // 뷰 계층 구성
        addSubview(radioButtonView)
        addSubview(titleLabel)
        radioButtonView.addSubview(innerDotView)
    }
    
    private func setupConstraints() {
        [radioButtonView, innerDotView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 높이
            heightAnchor.constraint(equalToConstant: 56),
            
            // 라디오 버튼
            radioButtonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            radioButtonView.centerYAnchor.constraint(equalTo: centerYAnchor),
            radioButtonView.widthAnchor.constraint(equalToConstant: 24),
            radioButtonView.heightAnchor.constraint(equalToConstant: 24),
            
            // 내부 점
            innerDotView.centerXAnchor.constraint(equalTo: radioButtonView.centerXAnchor),
            innerDotView.centerYAnchor.constraint(equalTo: radioButtonView.centerYAnchor),
            innerDotView.widthAnchor.constraint(equalToConstant: 12),
            innerDotView.heightAnchor.constraint(equalToConstant: 12),
            
            // 제목
            titleLabel.leadingAnchor.constraint(equalTo: radioButtonView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func viewTapped() {
        onTapped?()
    }
}
