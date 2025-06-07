//
//  DashboardViewController.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class DashboardViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    // 1번째 섹션: 주간 요약
    private let weeklySummaryView = WeeklySummaryView()
    
    // 2번째 섹션: 현재 설정/기록
    private let currentStatsView = CurrentStatsView()
    
    // 3번째 섹션: 그래프 (Mock)
    private let graphSectionHeader = SectionHeaderView()
    private let graphView = MockGraphView()
    
    // 4번째 섹션: 누적 기록
    private let recordSectionHeader = SectionHeaderView()
    private let recordStatsView = RecordStatsView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigationBar()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 그래프 강제 다시 그리기
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.graphView.redrawGraph() // ← MockGraphView의 public 메서드 호출
        }
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
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // 섹션 헤더 설정
        graphSectionHeader.configure(title: "그래프", showMoreButton: false)
        recordSectionHeader.configure(title: "누적 기록", showMoreButton: false)
        
        // 뷰 계층 구성
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // 스택뷰에 컴포넌트 추가
        stackView.addArrangedSubview(createSpacerView(height: 20))
        stackView.addArrangedSubview(weeklySummaryView)     // 1번째: 주간 요약
        stackView.addArrangedSubview(currentStatsView)     // 2번째: 현재 설정/기록
        stackView.addArrangedSubview(graphSectionHeader)   // 3번째: 그래프 헤더
        stackView.addArrangedSubview(graphView)            // 3번째: 그래프
        stackView.addArrangedSubview(recordSectionHeader)  // 4번째: 누적 기록 헤더
        stackView.addArrangedSubview(recordStatsView)      // 4번째: 누적 기록
        stackView.addArrangedSubview(createSpacerView(height: 32))
    }
    
    private func setupConstraints() {
        [scrollView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 스크롤뷰
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    
    private func setupNavigationBar() {
        // 네비게이션 바 숨김 (TabBar의 대시보드이므로)
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // Mock 데이터 로드
        weeklySummaryView.configure(with: WeeklyData.mockData)
        currentStatsView.configure(with: CurrentStatsData.mockData)
        recordStatsView.configure(with: RecordStatsData.mockData)
    }
    
    // MARK: - Helper Methods
    private func createSpacerView(height: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        return spacer
    }
}

// MARK: - Mock Data Models
struct WeeklyData {
    let weekRange: String
    let dailyStatus: [Bool] // 7개 (일~토)
    
    static let mockData = WeeklyData(
        weekRange: "2025.06.01 ~ 2025.06.08",
        dailyStatus: [true, false, true, false, true, true, false]
    )
}

struct CurrentStatsData {
    let stats: [String]
    
    static let mockData = CurrentStatsData(
        stats: [
            "금주 요약: 5/7 (71.4%)",
            "현재 Streak: 3일",
            "주간 코어 타임: 23시간 40분",
            "코어 타임 설정: 10:00 ~ 18:00"
        ]
    )
}

struct RecordStatsData {
    let records: [String]
    
    static let mockData = RecordStatsData(
        records: [
            "달성: 91/180",
            "마일스톤 누적 상위: 186 (Rank 60)",
            "최대 연속: 12 (Rank 46)",
            "누적 배지: 12 (Rank 32)",
            "총 코어 타임: ???"
        ]
    )
}
