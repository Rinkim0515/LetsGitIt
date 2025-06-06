//
//  ImageCell.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    
    static let identifier = "ImageCell"
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let altTextLabel = UILabel()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        altTextLabel.text = nil
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    
    // MARK: - Configuration
    func configure(with imageInfo: ImageInfo) {
        altTextLabel.text = imageInfo.altText.isEmpty ? "이미지" : imageInfo.altText
        
        // 로딩 시작
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        // TODO: 실제 이미지 로딩 (Kingfisher 등 사용 예정)
        // imageView.kf.setImage(with: URL(string: imageInfo.url)) { [weak self] result in
        //     DispatchQueue.main.async {
        //         self?.loadingIndicator.stopAnimating()
        //     }
        // }
        
        // 임시 이미지 로딩 시뮬레이션
        simulateImageLoading()
        
        print("🖼️ 이미지 로딩: \(imageInfo.url)")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정
        containerView.backgroundColor = UIColor(named: "Disable") ?? .systemGray5
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        
        // 이미지뷰 설정
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4
        imageView.clipsToBounds = true
        
        // 로딩 인디케이터
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .systemGray
        
        // Alt 텍스트 라벨
        altTextLabel.font = .pretendard(.regular, size: 10)
        altTextLabel.textColor = .secondaryLabel
        altTextLabel.textAlignment = .center
        altTextLabel.numberOfLines = 1
        altTextLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        altTextLabel.textColor = .white
        
        // 이미지 탭 제스처
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true
        
        // 뷰 계층 구성
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(loadingIndicator)
        containerView.addSubview(altTextLabel)
    }
    
    private func setupConstraints() {
        [containerView, imageView, loadingIndicator, altTextLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너 (셀 전체)
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // 이미지뷰 (Alt 텍스트 제외한 영역)
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: altTextLabel.topAnchor),
            
            // 로딩 인디케이터 (이미지뷰 중앙)
            loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            // Alt 텍스트 라벨 (하단 고정)
            altTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            altTextLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            altTextLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            altTextLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Actions
    @objc private func imageTapped() {
        // TODO: 이미지 전체화면 보기 구현
        print("🔍 이미지 탭됨 - 전체화면 보기")
        
        // 임시 애니메이션
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }
    
    // MARK: - Private Methods
    private func simulateImageLoading() {
        // 실제 네트워킹 라이브러리 사용 전까지 임시 시뮬레이션
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...2.0)) { [weak self] in
            self?.loadingIndicator.stopAnimating()
            
            // 임시 색상 이미지 생성
            self?.imageView.backgroundColor = [
                .systemBlue, .systemGreen, .systemOrange,
                .systemPurple, .systemPink, .systemTeal
            ].randomElement()
        }
    }
}
