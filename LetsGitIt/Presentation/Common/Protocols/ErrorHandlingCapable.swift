//
//  ErrorHandlingCapable.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import UIKit

// MARK: - ErrorHandlingCapable Protocol
protocol ErrorHandlingCapable {
    func showErrorAlert(message: String, completion: (() -> Void)?)
    func showConfirmationAlert(title: String, message: String, onConfirm: @escaping () -> Void, onCancel: (() -> Void)?)
}

extension ErrorHandlingCapable where Self: UIViewController {
    // MARK: - Error Alert (CustomAlert 사용)
    func showErrorAlert(message: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.presentCustomErrorAlert(message: message, completion: completion)
        }
    }
    
    // MARK: - Confirmation Alert (CustomAlert 사용)
    func showConfirmationAlert(
        title: String,
        message: String,
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            self.presentCustomConfirmationAlert(
                title: title,
                message: message,
                onConfirm: onConfirm,
                onCancel: onCancel
            )
        }
    }
    
    // MARK: - Private Implementation
    private func presentCustomErrorAlert(message: String, completion: (() -> Void)?) {
        let alert = CustomAlert.builder()
            .title("오류")
            .message(message)
            .singleAction(title: "확인")
            .primaryAction {
                completion?()
            }
            .build()
        
        alert.show(on: self)
    }
    
    private func presentCustomConfirmationAlert(
        title: String,
        message: String,
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)?
    ) {
        let alert = CustomAlert.builder()
            .title(title)
            .message(message)
            .dualAction(secondary: "취소", primary: "확인")
            .primaryAction(onConfirm)
            .secondaryAction(onCancel ?? {})
            .build()
        
        alert.show(on: self)
    }
}
// MARK: - Convenience Methods (자주 사용하는 패턴들)
extension ErrorHandlingCapable where Self: UIViewController {
    /// 네트워크 에러 전용 알럿
    func showNetworkErrorAlert(completion: (() -> Void)? = nil) {
        showErrorAlert(
            message: "네트워크 연결을 확인해주세요.",
            completion: completion
        )
    }
    
    /// 데이터 로딩 실패 알럿
    func showDataLoadingErrorAlert(completion: (() -> Void)? = nil) {
        showErrorAlert(
            message: "데이터를 불러오지 못했습니다. 다시 시도해주세요.",
            completion: completion
        )
    }
    
    /// 로그아웃 확인 알럿
    func showLogoutConfirmationAlert(onConfirm: @escaping () -> Void) {
        showConfirmationAlert(
            title: "로그아웃",
            message: "로그아웃 하시겠어요?",
            onConfirm: onConfirm,
            onCancel: nil
        )
    }
    
    /// 회원탈퇴 확인 알럿
    func showWithdrawConfirmationAlert(onConfirm: @escaping () -> Void) {
        showConfirmationAlert(
            title: "회원탈퇴",
            message: "정말로 탈퇴하시겠어요?",
            onConfirm: onConfirm,
            onCancel: nil
        )
    }
    
    /// 삭제 확인 알럿
    func showDeleteConfirmationAlert(itemName: String, onConfirm: @escaping () -> Void) {
        showConfirmationAlert(
            title: "삭제 확인",
            message: "\(itemName)을(를) 삭제하시겠어요?",
            onConfirm: onConfirm,
            onCancel: nil
        )
    }
    
    /// 코어타임 비활성화 확인 알럿
    func showCoreTimeDisableConfirmationAlert(onConfirm: @escaping () -> Void) {
        showConfirmationAlert(
            title: "코어타임 비활성화",
            message: "코어타임을 비활성화하시겠어요?",
            onConfirm: onConfirm,
            onCancel: nil
        )
    }
}
