//
//  ScrollViewCapableProtocol.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import UIKit
// MARK: - LoadingCapable Protocol
protocol LoadingCapable {
    func showLoading()
    func hideLoading()
}
// MARK: - Default Implementation
extension LoadingCapable where Self: UIViewController {
    func showLoading() {
        DispatchQueue.main.async {
            self.displayLoadingView()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.removeLoadingView()
        }
    }
    
    // MARK: - Private Implementation
    private func displayLoadingView() {
        // 이미 로딩뷰가 있다면 리턴
        guard view.viewWithTag(LoadingViewTag.loading.rawValue) == nil else { return }
        
        // 로딩 컨테이너 생성
        let loadingContainer = UIView()
        loadingContainer.tag = LoadingViewTag.loading.rawValue
        loadingContainer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        loadingContainer.alpha = 0
        
        // 로딩 인디케이터 생성
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        // 뷰 계층 구성
        loadingContainer.addSubview(activityIndicator)
        view.addSubview(loadingContainer)
        
        // 제약조건 설정
        setupLoadingViewConstraints(container: loadingContainer, indicator: activityIndicator)
        
        // 애니메이션으로 표시
        UIView.animate(withDuration: 0.2) {
            loadingContainer.alpha = 1.0
        }
    }
    
    private func removeLoadingView() {
        guard let loadingView = view.viewWithTag(LoadingViewTag.loading.rawValue) else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            loadingView.alpha = 0
        }) { _ in
            loadingView.removeFromSuperview()
        }
    }
    
    private func setupLoadingViewConstraints(container: UIView, indicator: UIActivityIndicatorView) {
        container.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 컨테이너를 전체 뷰에 맞춤
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 인디케이터를 중앙에 배치
            indicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
    
}
// MARK: - Loading View Tags
///일반적으로 개발자들이 tag를 1, 2, 3... 이런 식으로 사용
///999999처럼 큰 숫자를 사용하면 다른 태그와 충돌할 확률이 거의 없음
///enum으로 감싸서 매직 넘버 대신 의미있는 이름으로 사용
///

private enum LoadingViewTag: Int {
    case loading = 999999
}

