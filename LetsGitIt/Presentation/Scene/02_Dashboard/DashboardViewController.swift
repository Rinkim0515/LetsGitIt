//
//  DashboardViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class DashboardViewController: UIViewController {
    weak var coordinator: DashboardCoordinator?
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    // 1번째 섹션: 주간 요약
    private let titleView = TitleHeaderView()
    private let weeklyCalendarView = WeeklyCalendarView()
    private let currentStatsView = CurrentStatsView()
    private let weeklyGraphView = MockGraphView() // 기존 MockGraphView 재사용
    
    // 2번째 섹션: 누적 기록
    private let recordSectionHeader = TitleHeaderView()
    private let recordStatsView = RecordStatsView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.weeklyGraphView.redraw()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .backgroundSecondary
        
        // 스크롤뷰 설정
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        // 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // 섹션 헤더 설정
        setupSectionHeaders()
        
        // 뷰 계층 구성
        view.addSubview(scrollView)
        view.addSubview(titleView)
        scrollView.addSubview(stackView)
        
        
        // 주간 요약 섹션
        
        stackView.addArrangedSubview(weeklyCalendarView)     // 달력 (배경 없음)
        stackView.addArrangedSubview(currentStatsView)       // 현재 설정/기록 (배경 있음)
        stackView.addArrangedSubview(weeklyGraphView)        // 그래프 (배경 있음)
        
        // 누적 기록 섹션
        stackView.addArrangedSubview(recordSectionHeader)    // 헤더
        stackView.addArrangedSubview(recordStatsView)        // 누적 기록 (배경 있음)
        
        stackView.addArrangedSubview(UIView.createSpacerView(height: 32))
    }
    
    private func setupSectionHeaders() {
        // 현재 날짜 포맷팅
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd E"
        formatter.locale = Locale(identifier: "ko_KR")
        
        
        // 주간 요약 헤더
        titleView.configure(title: "주간 요약")
        // 우측에 현재 날짜 표시를 위해 커스텀 설정이 필요하다면 별도 구현
        
        // 누적 기록 헤더
        recordSectionHeader.configure(title: "누적 기록")
    }
    
    private func setupConstraints() {
        [titleView, scrollView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 스크롤뷰
            
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: titleView.bottomAnchor,constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 스택뷰
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    // MARK: - Data Loading
    private func loadData() {
        let weeklyData = MockData.weeklyData
        
        // 각 뷰에 데이터 전달
        weeklyCalendarView.configure(with: weeklyData)
        currentStatsView.configure(with: weeklyData)
        weeklyGraphView.configure(with: weeklyData) // ✅ 추가
        recordStatsView.configure(with: MockData.recordStatsData)
    }
    

}



struct RecordStatsData {
    let records: [String]
}
