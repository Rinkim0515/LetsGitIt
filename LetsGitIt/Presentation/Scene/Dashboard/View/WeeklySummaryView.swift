//
//  WeeklySummaryView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class WeeklySummaryView: UIView {
    
    // MARK: - UI Components
    private let containerView = UIView()
    
    // 상단: 섹션 타이틀과 날짜 범위
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let dateRangeLabel = UILabel()
    
    // 하단: 주간 달력
    private let calendarStackView = UIStackView()
    private var dayViews: [DayView] = []
    
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
        dateRangeLabel.text = data.weekRange
        
        // 오늘 날짜 계산 (목요일이라고 가정 - 인덱스 4)
        let todayIndex = 4 // 목요일 (실제로는 Calendar로 계산)
        
        // 각 날짜 뷰 업데이트
        for (index, dayView) in dayViews.enumerated() {
            let isChecked = data.dailyStatus[index]
            let isToday = index == todayIndex
            let day = getCurrentWeekDays()[index]
            
            dayView.configure(
                day: day,
                weekday: weekdays[index],
                isChecked: isChecked,
                isToday: isToday
            )
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정
        containerView.backgroundColor = UIColor(named: "BackgroundColor1") ?? .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        
        // 헤더 뷰 설정
        setupHeaderView()
        
        // 달력 스택뷰 설정
        setupCalendarView()
        
        // 뷰 계층 구성
        addSubview(containerView)
        containerView.addSubview(headerView)
        containerView.addSubview(calendarStackView)
    }
    
    private func setupHeaderView() {
        // 타이틀 라벨
        titleLabel.text = "주간 요약"
        titleLabel.font = .pretendard(.semiBold, size: 18)
        titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        
        // 날짜 범위 라벨
        dateRangeLabel.font = .pretendard(.regular, size: 14)
        dateRangeLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        dateRangeLabel.textAlignment = .right
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(dateRangeLabel)
    }
    
    private func setupCalendarView() {
        calendarStackView.axis = .horizontal
        calendarStackView.distribution = .fillEqually
        calendarStackView.spacing = 8
        
        // 7개의 날짜 뷰 생성
        for _ in 0..<7 {
            let dayView = DayView()
            dayViews.append(dayView)
            calendarStackView.addArrangedSubview(dayView)
        }
    }
    
    private func setupConstraints() {
        [containerView, headerView, titleLabel, dateRangeLabel, calendarStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 헤더 뷰
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 24),
            
            // 타이틀 라벨
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // 날짜 범위 라벨
            dateRangeLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            dateRangeLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            dateRangeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            
            // 달력 스택뷰
            calendarStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            calendarStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            calendarStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            calendarStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            calendarStackView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    // Mock 함수: 실제로는 Date() 기준으로 계산
    private func getCurrentWeekDays() -> [Int] {
        return [30, 1, 2, 3, 4, 5, 6] // 일~토 날짜들
    }
}

// MARK: - DayView
final class DayView: UIView {
    
    private let weekdayLabel = UILabel()
    private let dayLabel = UILabel()
    private let statusIcon = UILabel()
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
    
    func configure(day: Int, weekday: String, isChecked: Bool, isToday: Bool) {
        weekdayLabel.text = weekday
        dayLabel.text = "\(day)"
        
        // 배경 원 (오늘만 표시)
        backgroundCircle.isHidden = !isToday
        
        // 상태에 따른 색상 및 아이콘
        if isChecked {
            dayLabel.textColor = .systemBlue
            statusIcon.text = "✓"
            statusIcon.textColor = .systemBlue
        } else {
            dayLabel.textColor = .systemRed
            statusIcon.text = "✗"
            statusIcon.textColor = .systemRed
        }
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // 배경 원 (오늘 날짜 표시용)
        backgroundCircle.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        backgroundCircle.layer.cornerRadius = 20
        backgroundCircle.isHidden = true
        
        // 요일 라벨
        weekdayLabel.font = .pretendard(.light, size: 12)
        weekdayLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        weekdayLabel.textAlignment = .center
        
        // 날짜 라벨
        dayLabel.font = .pretendard(.semiBold, size: 18)
        dayLabel.textAlignment = .center
        
        // 상태 아이콘
        statusIcon.font = .systemFont(ofSize: 16, weight: .semibold)
        statusIcon.textAlignment = .center
        
        // 뷰 계층 구성
        addSubview(backgroundCircle)
        addSubview(weekdayLabel)
        addSubview(dayLabel)
        addSubview(statusIcon)
    }
    
    private func setupConstraints() {
        [backgroundCircle, weekdayLabel, dayLabel, statusIcon].forEach {
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
            
            // 상태 아이콘 (하단)
            statusIcon.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 4),
            statusIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusIcon.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
