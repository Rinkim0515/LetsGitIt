//
//  WeeklyCalendarView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class WeeklyCalendarView: UIView {
    
    // MARK: - UI Components
    private let calendarStackView = UIStackView()
    private var dayViews: [WeeklyDayView] = []
    
    // MARK: - Properties
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
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
    func configure(with data: WeeklyData) {
        let weekDays = MockData.DayInMonth
        
        for (index, dayView) in dayViews.enumerated() {
            let dayNumber = weekDays[index]
            let weekday = weekdays[index]
            let status = data.dailyStatuses[index]
            
            dayView.configure(
                day: dayNumber,
                weekday: weekday,
                status: status
            )
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear // 배경 투명
        
        // 달력 스택뷰 설정
        calendarStackView.axis = .horizontal
        calendarStackView.distribution = .fillEqually
        calendarStackView.spacing = 0
        
        // 7개의 날짜 뷰 생성
        for _ in 0..<7 {
            let dayView = WeeklyDayView()
            dayViews.append(dayView)
            calendarStackView.addArrangedSubview(dayView)
        }
        
        // 뷰 계층 구성
        addSubview(calendarStackView)
    }
    
    private func setupConstraints() {
        calendarStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 달력 스택뷰
            calendarStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            calendarStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            calendarStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            calendarStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            calendarStackView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
}

// MARK: - WeeklyDayView
final class WeeklyDayView: UIView {
    
    private let weekdayLabel = UILabel()
    private let dayLabel = UILabel()
    private let statusView = UIView()
    private let statusLabel = UILabel()
    private let backgroundCircle = UIView()
    
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
    
    func configure(day: Int, weekday: String, status: DayStatus) {
        weekdayLabel.text = weekday
        dayLabel.text = "\(day)"
        
        switch status {
        case .past(let isClosed):
            setupPastDay(isClosed: isClosed)
            
        case .today:
            setupToday()
            
        case .future(let milestoneCount):
            setupFutureDay(milestoneCount: milestoneCount)
        }
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // 배경 원 (오늘 날짜 표시용)
        backgroundCircle.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        backgroundCircle.layer.cornerRadius = 20
        backgroundCircle.isHidden = true
        
        // 요일 라벨
        weekdayLabel.font = .pretendard(.regular, size: 12)
        weekdayLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        weekdayLabel.textAlignment = .center
        
        // 날짜 라벨
        dayLabel.font = .pretendard(.semiBold, size: 18)
        dayLabel.textAlignment = .center
        dayLabel.textColor = .white
        
        // 상태 뷰 (체크/X/마일스톤)
        statusView.layer.cornerRadius = 12
        statusView.isHidden = true
        
        // 상태 라벨
        statusLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        statusLabel.textAlignment = .center
        statusLabel.textColor = .white
        
        // 뷰 계층 구성
        addSubview(backgroundCircle)
        addSubview(weekdayLabel)
        addSubview(dayLabel)
        addSubview(statusView)
        statusView.addSubview(statusLabel)
    }
    
    private func setupConstraints() {
        [backgroundCircle, weekdayLabel, dayLabel, statusView, statusLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 배경 원
            backgroundCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundCircle.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            backgroundCircle.widthAnchor.constraint(equalToConstant: 40),
            backgroundCircle.heightAnchor.constraint(equalToConstant: 40),
            
            // 요일 라벨 (상단)
            weekdayLabel.topAnchor.constraint(equalTo: topAnchor),
            weekdayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // 날짜 라벨 (중간)
            dayLabel.topAnchor.constraint(equalTo: weekdayLabel.bottomAnchor, constant: 8),
            dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // 상태 뷰 (하단)
            statusView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 4),
            statusView.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusView.widthAnchor.constraint(equalToConstant: 24),
            statusView.heightAnchor.constraint(equalToConstant: 24),
            statusView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 상태 라벨
            statusLabel.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor)
        ])
    }
    
    private func setupPastDay(isClosed: Bool) {
        backgroundCircle.isHidden = true
        statusView.isHidden = false
        
        if isClosed {
            statusView.backgroundColor = .systemBlue
            statusLabel.text = "✓"
            statusLabel.textColor = .white
        } else {
            statusView.backgroundColor = .systemRed
            statusLabel.text = "✗"
            statusLabel.textColor = .white
        }
    }
    
    private func setupToday() {
        backgroundCircle.isHidden = false
        statusView.isHidden = true
        dayLabel.textColor = .white
    }
    
    private func setupFutureDay(milestoneCount: Int?) {
        backgroundCircle.isHidden = true
        
        if let count = milestoneCount, count > 0 {
            statusView.isHidden = false
            statusView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
            statusLabel.text = "+\(count)"
            statusLabel.textColor = .white
            statusLabel.font = .pretendard(.regular, size: 10)
        } else {
            statusView.isHidden = true
        }
    }
}

// MARK: - Data Models
enum DayStatus {
    case past(isClosed: Bool)
    case today
    case future(milestoneCount: Int?)
}

struct WeeklyData {
    let weekRange: String
    let currentDate: Date
    let dailyStatuses: [DayStatus]
    let summary: String
    let currentStreak: Int
    let weeklyTotalHours: String
    let coreTimeSettings: String
    
    
}
