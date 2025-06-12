//
//  TimePickerViewController.swift
//  LetsGitIt
//
//  Created by Developer on 2025.06.09.
//

import UIKit

final class CoreTimeSettingVC: UIViewController {
    weak var coordinator: SettingsCoordinator?
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let headerView = TitleHeaderView()
    private let datePicker = UIDatePicker()
    private let updateButton = UIButton(type: .system)
    
    // MARK: - Properties
    private let titleText: String
    private let initialTime: Date
    var onTimeSelected: ((Date) -> Void)?
    
    // MARK: - Initialization
    init(title: String, initialTime: Date) {
        self.titleText = title
        self.initialTime = initialTime
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
        headerView.configure(title: titleText, showMoreButton: false)
        
        // DatePicker 설정
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minuteInterval = 5
        datePicker.date = initialTime
        
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
        stackView.addArrangedSubview(datePicker)
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
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -34),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            // 업데이트 버튼
            updateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc private func updateButtonTapped() {
        onTimeSelected?(datePicker.date)
        coordinator?.dismissModal()
    }
}
