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
    
    // 현재 설정값들
    private var startTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    private var endTime: Date = Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date()) ?? Date()
    private var selectedWeekdays: Set<Int> = []
    private var selectedNotification: NotificationOption = .none
    
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
        backgroundColor = .backgroundColor2
        
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
            rightText: formatTime(startTime)
        ) { [weak self] in
            self?.presentStartTimePicker()
        }
        
        // 종료시간
        endTimeRow.configure(
            title: "종료시간",
            rightText: formatTime(endTime)
        ) { [weak self] in
            self?.presentEndTimePicker()
        }
        
        // 요일설정
        weekdaysRow.configure(
            title: "요일설정",
            rightText: formatWeekdays(selectedWeekdays)
        ) { [weak self] in
            self?.presentWeekdaySelector()
        }
        
        // 시작 전 알림
        notificationRow.configure(
            title: "시작 전 알림",
            rightText: selectedNotification.displayText
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
    
    // MARK: - Modal Presentation
    private func presentStartTimePicker() {
        let timePickerVC = CoreTimeSettingVC(title: "시작시간", initialTime: startTime)
        
        timePickerVC.onTimeSelected = { [weak self] selectedTime in
            self?.startTime = selectedTime
            self?.updateStartTimeDisplay()
        }
        
        presentModal(timePickerVC, height: .medium)
    }
    
    private func presentEndTimePicker() {
        let timePickerVC = CoreTimeSettingVC(title: "종료시간", initialTime: endTime)
        
        timePickerVC.onTimeSelected = { [weak self] selectedTime in
            self?.endTime = selectedTime
            self?.updateEndTimeDisplay()
        }
        
        presentModal(timePickerVC, height: .medium)
    }
    
    private func presentWeekdaySelector() {
        let weekdayVC = WeekdaySettingVC(selectedDays: selectedWeekdays)
        
        weekdayVC.onSelectionChanged = { [weak self] selectedDays in
            self?.selectedWeekdays = Set(selectedDays)
            self?.updateWeekdaysDisplay()
        }
        
        presentModal(weekdayVC, height: .large) // 70% 크기
    }
    
    private func presentNotificationSettings() {
        let notificationVC = NotiSettingVC(selectedOption: selectedNotification)
        
        notificationVC.onSelectionChanged = { [weak self] selectedOption in
            self?.selectedNotification = selectedOption
            self?.updateNotificationDisplay()
        }
        
        presentModal(notificationVC, height: .medium)
    }
    
    // MARK: - Helper Methods
    private func presentModal(_ viewController: UIViewController, height: ModalHeight) {
        guard let parentVC = findViewController() else { return }
        
        if #available(iOS 15.0, *) {
            viewController.modalPresentationStyle = .pageSheet
            
            if let sheet = viewController.sheetPresentationController {
                switch height {
                case .medium:
                    sheet.detents = [.medium()]
                case .large:
                    sheet.detents = [
                        .custom(identifier: .init("weekdays")) { context in
                            return context.maximumDetentValue * 0.7  // 70%
                        }
                    ]
                }
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
            }
        } else {
            viewController.modalPresentationStyle = .formSheet
        }
        
        parentVC.present(viewController, animated: true)
    }
    
    private func updateStartTimeDisplay() {
        startTimeRow.updateRightText(formatTime(startTime))
    }
    
    private func updateEndTimeDisplay() {
        endTimeRow.updateRightText(formatTime(endTime))
    }
    
    private func updateWeekdaysDisplay() {
        weekdaysRow.updateRightText(formatWeekdays(selectedWeekdays))
    }
    
    private func updateNotificationDisplay() {
        notificationRow.updateRightText(selectedNotification.displayText)
    }
    
    // MARK: - Formatting Methods
    private func formatTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
    
    private func formatWeekdays(_ weekdays: Set<Int>) -> String {
        if weekdays.isEmpty {
            return "설정하기"
        }
        
        let weekdayNames = ["월", "화", "수", "목", "금", "토", "일"]
        let selectedNames = weekdays.sorted().compactMap { index in
            index < weekdayNames.count ? weekdayNames[index] : nil
        }
        
        if selectedNames.count == 7 {
            return "매일"
        } else if selectedNames.count <= 3 {
            return selectedNames.joined(separator: ", ")
        } else {
            return "\(selectedNames.count)일 선택"
        }
    }
    
    // MARK: - Settings Persistence (임시)
    private func loadSettings() {
        coreTimeEnabled = UserDefaults.standard.bool(forKey: "coreTimeEnabled")
        // TODO: 다른 설정값들도 로드
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(coreTimeEnabled, forKey: "coreTimeEnabled")
        // TODO: 다른 설정값들도 저장
    }
}

// MARK: - Modal Height Enum
private enum ModalHeight {
    case medium  // 50%
    case large   // 70%
}

// MARK: - UIView Extension
extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
