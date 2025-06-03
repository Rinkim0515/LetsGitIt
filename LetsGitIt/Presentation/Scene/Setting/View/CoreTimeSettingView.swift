//
//  CoreTimeSettingView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/3/25.
//

import UIKit

final class CoreTimeSettingsView: UIView {
    
    // MARK: - UI Components
    private let stackView = UIStackView()
    
    // 코어타임 토글
    private let coreTimeToggleRow = SettingsToggleRow()
    
    // 설정 행들
    private let startTimeRow = SettingsActionRow()
    private let endTimeRow = SettingsActionRow()
    private let weekdaysRow = SettingsActionRow()
    private let notificationRow = SettingsActionRow()
    
    // MARK: - Properties
    private var coreTimeEnabled: Bool = false {
        didSet {
            updateSettingsRowsState()
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        configureRows()
        loadSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        configureRows()
        loadSettings()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .backgroundPrimary
        
        // 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // 뷰 계층 구성
        addSubview(stackView)
        
        stackView.addArrangedSubview(coreTimeToggleRow)
        stackView.addArrangedSubview(startTimeRow)
        stackView.addArrangedSubview(endTimeRow)
        stackView.addArrangedSubview(weekdaysRow)
        stackView.addArrangedSubview(notificationRow)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    private func configureRows() {
        // 코어타임 토글
        coreTimeToggleRow.configure(
            title: "코어타임",
            isOn: coreTimeEnabled
        ) { [weak self] isOn in
            self?.coreTimeEnabled = isOn
            self?.saveSettings()
        }
        
        // 시작시간
        startTimeRow.configure(
            title: "시작시간",
            rightText: "설정하기"
        ) { [weak self] in
            self?.presentTimePickerForStartTime()
        }
        
        // 종료시간
        endTimeRow.configure(
            title: "종료시간",
            rightText: "설정하기"
        ) { [weak self] in
            self?.presentTimePickerForEndTime()
        }
        
        // 요일설정
        weekdaysRow.configure(
            title: "요일설정",
            rightText: "설정하기"
        ) { [weak self] in
            self?.presentWeekdaySelector()
        }
        
        // 시작 전 알림
        notificationRow.configure(
            title: "시작 전 알림",
            rightText: "설정하기"
        ) { [weak self] in
            self?.presentNotificationSettings()
        }
    }
    
    private func updateSettingsRowsState() {
        let alpha: CGFloat = coreTimeEnabled ? 1.0 : 0.5
        let isEnabled = coreTimeEnabled
        
        startTimeRow.alpha = alpha
        startTimeRow.isUserInteractionEnabled = isEnabled
        
        endTimeRow.alpha = alpha
        endTimeRow.isUserInteractionEnabled = isEnabled
        
        weekdaysRow.alpha = alpha
        weekdaysRow.isUserInteractionEnabled = isEnabled
        
        notificationRow.alpha = alpha
        notificationRow.isUserInteractionEnabled = isEnabled
    }
    
    // MARK: - Settings Actions
    private func presentTimePickerForStartTime() {
        // TODO: 시작시간 선택 화면
        print("시작시간 설정")
    }
    
    private func presentTimePickerForEndTime() {
        // TODO: 종료시간 선택 화면
        print("종료시간 설정")
    }
    
    private func presentWeekdaySelector() {
        // TODO: 요일 선택 화면
        print("요일 설정")
    }
    
    private func presentNotificationSettings() {
        // TODO: 알림 설정 화면
        print("알림 설정")
    }
    
    // MARK: - Settings Persistence
    private func loadSettings() {
        coreTimeEnabled = UserDefaults.standard.bool(forKey: "coreTimeEnabled")
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(coreTimeEnabled, forKey: "coreTimeEnabled")
    }
}
