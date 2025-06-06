//
//  CommentCell.swift
//  LetsGitIt
//
//  Created by KimRin on 6/6/25.
//


import UIKit

final class CommentCell: UICollectionViewCell {
    
    static let identifier = "CommentCell"
    
    // MARK: - UI Components
    private let containerView = UIView()
    
    // 상단: 작성자 정보
    private let avatarImageView = UIImageView()
    private let authorLabel = UILabel()
    private let dateLabel = UILabel()
    
    // 중간: 텍스트 영역 (조건부 표시)
    private let textContainerView = UIView()
    private let contentLabel = UILabel()
    
    // 하단: 이미지 영역 (조건부 표시)
    private let imageContainerView = UIView()
    private let imageCollectionView: UICollectionView
    private let flowLayout = UICollectionViewFlowLayout()
    
    // MARK: - Properties
    private var images: [ImageInfo] = []
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        // CollectionView 초기화
        self.imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupImageCollectionView()
    }
    
    required init?(coder: NSCoder) {
        self.imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        setupImageCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        contentLabel.attributedText = nil
        dateLabel.text = nil
        avatarImageView.image = nil
        images = []
        imageCollectionView.reloadData()
        
        // 영역 초기화
        textContainerView.isHidden = false
        imageContainerView.isHidden = false
    }
    
    // MARK: - Configuration
    func configure(with comment: CommentItem) {
        // 기본 정보 설정
        authorLabel.text = comment.author
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        dateLabel.text = formatter.string(from: comment.createdAt)
        
        // 아바타 설정 (임시)
        avatarImageView.backgroundColor = .systemBlue
        
        // 파싱된 콘텐츠 적용
        let parsed = comment.parsedContent
        
        // 텍스트 영역 설정
        if parsed.hasText, let attributedText = parsed.attributedText {
            textContainerView.isHidden = false
            contentLabel.attributedText = attributedText
        } else {
            textContainerView.isHidden = true
        }
        
        // 이미지 영역 설정
        if !parsed.images.isEmpty {
            imageContainerView.isHidden = false
            images = parsed.images
            imageCollectionView.reloadData()
        } else {
            imageContainerView.isHidden = true
        }
        
        print("💬 \(comment.author): 텍스트=\(parsed.hasText), 이미지=\(parsed.images.count)개")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .clear
        
        // 컨테이너 설정
        containerView.backgroundColor = UIColor(named: "BackgroundColor1") ?? .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(named: "Separator")?.cgColor ?? UIColor.separator.cgColor
        
        // 아바타 이미지뷰
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        
        // 작성자 라벨
        authorLabel.font = .pretendard(.semiBold, size: 14)
        authorLabel.textColor = UIColor(named: "PrimaryText") ?? .label
        
        // 날짜 라벨
        dateLabel.font = .pretendard(.regular, size: 12)
        dateLabel.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        
        // 텍스트 컨테이너
        textContainerView.backgroundColor = .clear
        
        // 내용 라벨 (AttributedString 지원)
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        
        // 이미지 컨테이너
        imageContainerView.backgroundColor = .clear
        
        // 뷰 계층 구성
        contentView.addSubview(containerView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(authorLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(textContainerView)
        containerView.addSubview(imageContainerView)
        
        textContainerView.addSubview(contentLabel)
        imageContainerView.addSubview(imageCollectionView)
    }
    
    private func setupConstraints() {
        [containerView, avatarImageView, authorLabel, dateLabel,
         textContainerView, contentLabel, imageContainerView, imageCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // 컨테이너
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // 아바타 이미지
            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 32),
            avatarImageView.heightAnchor.constraint(equalToConstant: 32),
            
            // 작성자 라벨
            authorLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            
            // 날짜 라벨
            dateLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: authorLabel.trailingAnchor, constant: 8),
            
            // 텍스트 컨테이너
            textContainerView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            textContainerView.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            textContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // 내용 라벨
            contentLabel.topAnchor.constraint(equalTo: textContainerView.topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor),
            
            // 이미지 컨테이너
            imageContainerView.topAnchor.constraint(equalTo: textContainerView.bottomAnchor, constant: 8),
            imageContainerView.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            imageContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            imageContainerView.heightAnchor.constraint(equalToConstant: 120), // 이미지 영역 고정 높이
            
            // 이미지 CollectionView
            imageCollectionView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor)
        ])
    }
    
    private func setupImageCollectionView() {
        // FlowLayout 설정 (가로 스크롤)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 0
        
        // CollectionView 설정
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.showsHorizontalScrollIndicator = false
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        // 이미지 셀 등록
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    }
}

// MARK: - UICollectionViewDataSource
extension CommentCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        let image = images[indexPath.item]
        cell.configure(with: image)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CommentCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 이미지 셀 크기 (정사각형)
        let height = collectionView.frame.height
        return CGSize(width: height, height: height)
    }
}
