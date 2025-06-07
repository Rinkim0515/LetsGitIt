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
    
    // 그래프 점들과 선
    private var dotViews: [UIView] = []
    private var lineLayer: CAShapeLayer?
    
    // MARK: - Properties
    // Mock 데이터 (0.0 ~ 1.0 범위)
    private let mockData: [CGFloat] = [0.3, 0.7, 0.2, 0.9, 0.5, 0.8, 0.4]
    
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
    func redrawGraph() {
        DispatchQueue.main.async {
            self.drawGraph()
        }
    }
    private func drawGraph() {
        print("🔧 drawGraph 호출됨")
            print("📏 graphAreaView 크기: \(graphAreaView.bounds)")
        // 기존 그래프 요소들 제거
        lineLayer?.removeFromSuperlayer()
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()
        
        guard graphAreaView.bounds.width > 0 && graphAreaView.bounds.height > 0 else { return }
        
        let graphWidth = graphAreaView.bounds.width
        let graphHeight = graphAreaView.bounds.height
        let pointSpacing = graphWidth / CGFloat(mockData.count - 1)
        
        // 선을 그리기 위한 패스 생성
        let linePath = UIBezierPath()
        var points: [CGPoint] = []
        
        // 각 데이터 포인트에 대해 점과 좌표 계산
        for (index, value) in mockData.enumerated() {
            let x = CGFloat(index) * pointSpacing
            let y = graphHeight - (value * graphHeight) // Y축 뒤집기 (위쪽이 높은 값)
            let point = CGPoint(x: x, y: y)
            points.append(point)
            
            // 점 생성
            createDot(at: point, isActive: value > 0.5)
            
            // 선 패스에 포인트 추가
            if index == 0 {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }
        }
        
        // 선 그리기
        drawLine(with: linePath)
    }
    
    private func createDot(at point: CGPoint, isActive: Bool) {
        let dotSize: CGFloat = 8
        let dot = UIView()
        
        dot.frame = CGRect(
            x: point.x - dotSize/2,
            y: point.y - dotSize/2,
            width: dotSize,
            height: dotSize
        )
        
        dot.backgroundColor = isActive ? .systemBlue : .systemGray3
        dot.layer.cornerRadius = dotSize / 2
        dot.layer.borderWidth = 2
        dot.layer.borderColor = UIColor.white.cgColor
        
        graphAreaView.addSubview(dot)
        dotViews.append(dot)
    }
    
    private func drawLine(with path: UIBezierPath) {
        lineLayer = CAShapeLayer()
        lineLayer!.path = path.cgPath
        lineLayer!.strokeColor = UIColor.systemBlue.cgColor
        lineLayer!.fillColor = UIColor.clear.cgColor
        lineLayer!.lineWidth = 2
        lineLayer!.lineCap = .round
        lineLayer!.lineJoin = .round
        
        graphAreaView.layer.addSublayer(lineLayer!)
    }
}
