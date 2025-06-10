//
//  WeekdaySelectionViewController.swift
//  LetsGitIt
//
//  Created by Developer on 2025.06.09.
//

import UIKit

final class WeekdaySelectionViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let headerView = TitleHeaderView()
    private let allSelectRow = WeekdayCheckRow()
    private let separatorView = UIView()
    private let weekdayStackView = UIStackView()
    private let updateButton = UIButton(type: .system)
    
    // MARK: - Properties
    private let weekdays = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
    private var selectedDays: Set<Int> = []
    private var weekdayRows: [WeekdayCheckRow] = []
    var onSelectionChanged: (([Int]) -> Void)?
    
    // MARK: - Initialization
    init(selectedDays: Set<Int> = []) {
        self.selectedDays = selectedDays
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
        updateAllSelectState()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor1") ?? .systemBackground
        
        // ScrollView 설정
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        // StackView 설정
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        
        // Header 설정
        headerView.configure(title: "요일 설정", showMoreButton: false)
        
        // 전체 선택 행
        allSelectRow.configure(title: "전체 선택", isSelected: false) { [weak self] in
            self?.allSelectTapped()
        }
        
        // 구분선
        separatorView.backgroundColor = UIColor(named: "Separator") ?? .separator
        
        // 요일 스택뷰
        weekdayStackView.axis = .vertical
        weekdayStackView.spacing = 0
        weekdayStackView.alignment = .fill
        
        // 개별 요일 행들 생성
        for (index, weekday) in weekdays.enumerated() {
            let weekdayRow = WeekdayCheckRow()
            let isSelected = selectedDays.contains(index)
            
            weekdayRow.configure(title: weekday, isSelected: isSelected) { [weak self] in
                self?.weekdayTapped(index: index)
            }
            
            weekdayRows.append(weekdayRow)
            weekdayStackView.addArrangedSubview(weekdayRow)
        }
        
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
        stackView.addArrangedSubview(allSelectRow)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(weekdayStackView)
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
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -34),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 구분선
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            // 업데이트 버튼
            updateButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            updateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    private func allSelectTapped() {
        if selectedDays.count == weekdays.count {
            // 전체 선택된 상태 → 모두 해제
            selectedDays.removeAll()
        } else {
            // 일부만 선택되어 있거나 아무것도 선택 안된 상태 → 모두 선택
            selectedDays = Set(0..<weekdays.count)
        }
        
        updateWeekdayRows()
        updateAllSelectState()
    }
    
    private func weekdayTapped(index: Int) {
        if selectedDays.contains(index) {
            selectedDays.remove(index)
        } else {
            selectedDays.insert(index)
        }
        
        updateWeekdayRows()
        updateAllSelectState()
    }
    
    private func updateWeekdayRows() {
        for (index, row) in weekdayRows.enumerated() {
            row.updateSelection(selectedDays.contains(index))
        }
    }
    
    private func updateAllSelectState() {
        let isAllSelected = selectedDays.count == weekdays.count
        allSelectRow.updateSelection(isAllSelected)
    }
    
    @objc private func updateButtonTapped() {
        let selectedDaysArray = selectedDays.sorted()
        onSelectionChanged?(selectedDaysArray)
        dismiss(animated: true)
    }
}

// MARK: - WeekdayCheckRow
final class WeekdayCheckRow: UIView {
    
    private let containerView = UIView()
    private let checkboxImageView = UIImageView()
    private let titleLabel = UILabel()
    private var onTapped: (() -> Void)?
    
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
    
    func configure(title: String, isSelected: Bool, onTapped: @escaping () -> Void) {
        titleLabel.text = title
        self.onTapped = onTapped
        updateSelection(isSelected)
    }
    
    func updateSelection(_ isSelected: Bool) {
        let imageName = isSelected ? "checkmark.square.fill" : "square"
        checkboxImageView.image = UIImage(systemName: imageName)
        checkboxImageView.tintColor = isSelected ? .systemBlue : .systemGray3
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // 체크박스 이미지
        checkboxImageView.contentMode = .scaleAspectFit
        checkboxImageView.tintColor = .systemGray3
        
        // 제목 라벨
        titleLabel.font = .pretendard(.regular, size: 16)
        titleLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        
        // 탭 제스처
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
        
        // 뷰 계층 구성
        addSubview(checkboxImageView)
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        [checkboxImageView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 높이
            heightAnchor.constraint(equalToConstant: 56),
            
            // 체크박스
            checkboxImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            checkboxImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkboxImageView.widthAnchor.constraint(equalToConstant: 24),
            checkboxImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // 제목
            titleLabel.leadingAnchor.constraint(equalTo: checkboxImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func viewTapped() {
        onTapped?()
    }
}
