//
//  MockGraphView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class MockGraphView: UIView {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let graphAreaView = UIView()
    
    // X축 라벨들 (요일)
    private let xAxisStackView = UIStackView()
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private var weeklyData: WeeklyData?
    
    // 그래프 점들과 선
    private var dotViews: [UIView] = []
    private var lineLayer: CAShapeLayer?
    
    
    private var hasDrawn = false
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasDrawn && graphAreaView.bounds.width > 0 {
            drawGraph()
            hasDrawn = true
        }
    }
    
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정
        containerView.backgroundColor = UIColor(named: "BackgroundColor1") ?? .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        
        // 그래프 영역 설정
        graphAreaView.backgroundColor = .clear
        
        // X축 스택뷰 설정
        setupXAxisLabels()
        
        // 뷰 계층 구성
        addSubview(containerView)
        containerView.addSubview(graphAreaView)
        containerView.addSubview(xAxisStackView)
    }
    
    private func setupXAxisLabels() {
        xAxisStackView.axis = .horizontal
        xAxisStackView.distribution = .fillEqually
        xAxisStackView.alignment = .center
        
        // 요일 라벨들 추가
        for weekday in weekdays {
            let label = UILabel()
            label.text = weekday
            label.font = .pretendard(.regular, size: 12)
            label.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
            label.textAlignment = .center
            
            xAxisStackView.addArrangedSubview(label)
        }
    }
    
    private func setupConstraints() {
        [containerView, graphAreaView, xAxisStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            // 그래프 영역
            graphAreaView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            graphAreaView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            graphAreaView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            graphAreaView.heightAnchor.constraint(equalToConstant: 120),
            
            // X축 라벨들
            xAxisStackView.topAnchor.constraint(equalTo: graphAreaView.bottomAnchor, constant: 10),
            xAxisStackView.leadingAnchor.constraint(equalTo: graphAreaView.leadingAnchor),
            xAxisStackView.trailingAnchor.constraint(equalTo: graphAreaView.trailingAnchor),
            xAxisStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            xAxisStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with weeklyData: WeeklyData) {
        self.weeklyData = weeklyData
        drawGraph()
    }
    
    func redraw() {
        DispatchQueue.main.async{
            self.drawGraph()
        }
    }
    
    private func drawGraph() {
        // 기존 그래프 요소들 제거
        lineLayer?.removeFromSuperlayer()
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()
        
        guard graphAreaView.bounds.width > 0 && graphAreaView.bounds.height > 0 else { return }
        
        let graphWidth = graphAreaView.bounds.width
        let graphHeight = graphAreaView.bounds.height
        let pointSpacing = graphWidth / CGFloat(7)
        
        // 선을 그리기 위한 패스 생성
        let linePath = UIBezierPath()
        var points: [CGPoint] = []
        var statuses: [DayStatus] = []
        
        // WeeklyData가 있으면 실제 데이터 사용, 없으면 Mock 데이터
        let dataToUse = weeklyData?.dailyStatuses ?? MockData.graph.enumerated().map { index, value in
            return value > 0.5 ? DayStatus.past(isClosed: true) : DayStatus.past(isClosed: false)
        }
        
        // 각 데이터 포인트 좌표 계산
        for (index, status) in dataToUse.enumerated() {
            let x = (CGFloat(index) + 0.5) * pointSpacing
            
            let yValue: CGFloat
            switch status {
            case .past(let isClosed):
                yValue = isClosed ? 1.0 : 0.0
            case .today:
                yValue = 0.5
            case .future:
                yValue = 0.5
            }
            
            let y = graphHeight - (yValue * graphHeight)
            let point = CGPoint(x: x, y: y)
            points.append(point)
            statuses.append(status)
            
            // 선 패스에 포인트 추가
            if index == 0 {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }
        }
        
        // ✅ 1. 먼저 선 그리기
        drawLine(with: linePath)
        
        // ✅ 2. 그 다음 점들 그리기 (선 위에 올라감)
        for (index, point) in points.enumerated() {
            createDot(at: point, status: statuses[index])
        }
    }
    
    
    
    private func createDot(at point: CGPoint, status: DayStatus) {
        let dotSize: CGFloat = 8
        let dot = UIView()
        
        dot.frame = CGRect(
            x: point.x - dotSize/2,
            y: point.y - dotSize/2,
            width: dotSize,
            height: dotSize
        )
        
        // 상태에 따른 색상 결정
        switch status {
        case .past(let isClosed):
            dot.backgroundColor = isClosed ? .systemBlue : .systemRed
        case .today:
            dot.backgroundColor = .systemBlue // 오늘은 파란색
        case .future:
            dot.backgroundColor = .systemGray // 미래는 회색
        }
        
        dot.layer.cornerRadius = dotSize / 2
        // ✅ 테두리 제거
        dot.layer.borderWidth = 0
        
        graphAreaView.addSubview(dot)
        dotViews.append(dot)
    }
    
    private func drawLine(with path: UIBezierPath) {
        lineLayer = CAShapeLayer()
        lineLayer!.path = path.cgPath
        // ✅ 선 색상을 회색으로 변경
        lineLayer!.strokeColor = UIColor.systemGray3.cgColor
        lineLayer!.fillColor = UIColor.clear.cgColor
        lineLayer!.lineWidth = 2
        lineLayer!.lineCap = .round
        lineLayer!.lineJoin = .round
        
        graphAreaView.layer.addSublayer(lineLayer!)
    }
}
