//
//  SectionHeaderView.swift
//  LetsGitIt
//
//  Created by KimRin on 6/2/25.
//

import UIKit

final class SectionHeaderView: UIView {
    
    // MARK: - UI Components
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let moreButton = UIButton(type: .system)
    
    // MARK: - Properties
    var onMoreTapped: (() -> Void)?
    
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
    func configure(title: String, showMoreButton: Bool = true) {
        titleLabel.text = title
        moreButton.isHidden = !showMoreButton
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .clear
        
        // 제목 라벨 설정
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        // 더보기 버튼 설정
        moreButton.setTitle("더보기", for: .normal)
        moreButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        moreButton.setTitleColor(UIColor(named: "BrandMainColor") ?? .systemBlue, for: .normal)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        moreButton.setContentHuggingPriority(.required, for: .horizontal)
        moreButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // 버튼 터치 효과 추가
        moreButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        moreButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // 스택뷰 설정
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        
        // 뷰 계층 구성
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(moreButton)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 스택뷰
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            // 최소 높이 보장
            heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
    
    // MARK: - Actions
    @objc private func moreButtonTapped() {
        onMoreTapped?()
    }
    
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.moreButton.alpha = 0.6
        }
    }
    
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.moreButton.alpha = 1.0
        }
    }
}

// MARK: - 사용 예시
/*
 사용법:
 
 // 기본 사용 (더보기 버튼 있음)
 let milestoneHeader = SectionHeaderView()
 milestoneHeader.configure(title: "중요한 마일스톤")
 milestoneHeader.onMoreTapped = {
     print("마일스톤 더보기 클릭")
     // 마일스톤 전체 목록 화면으로 이동
 }
 
 // 더보기 버튼 없는 버전
 let settingsHeader = SectionHeaderView()
 settingsHeader.configure(title: "계정 설정", showMoreButton: false)
 
 // 스택뷰에 추가
 stackView.addArrangedSubview(milestoneHeader)
 stackView.addArrangedSubview(milestonePreviewView)
 
 stackView.addArrangedSubview(issueHeader)
 stackView.addArrangedSubview(issuePreviewView)
 */
