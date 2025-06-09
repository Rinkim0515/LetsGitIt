//
//  TestData.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import Foundation

extension CommentItem {
    static let mockComments: [CommentItem] = [
        // 1. 텍스트만
        CommentItem(
            id: "1",
            author: "boris7422",
            avatarURL: nil,
            createdAt: Date(),
            originalContent: """
            **버그 발생!** 앱이 _정말_ 이상하게 동작합니다.
            
            재현 방법:
            1. 로그인
            2. **설정** 페이지 이동
            3. `다크모드` 버튼 클릭
            
            급하게 수정 부탁드립니다! 🙏
            """
        ),
        
        // 2. 이미지만
        CommentItem(
            id: "2",
            author: "abcd1234",
            avatarURL: nil,
            createdAt: Date(),
            originalContent: "![스크린샷](https://user-images.githubusercontent.com/12345/screenshot.png)"
        ),
        
        // 3. 텍스트 + 이미지 (혼합)
        CommentItem(
            id: "3",
            author: "developer123",
            avatarURL: nil,
            createdAt: Date(),
            originalContent: """
            ### 문제 재현 완료 ✅
            
            다음과 같은 **에러**가 발생합니다:
            
            ![에러 스크린샷](https://user-images.githubusercontent.com/67890/error.png)
            
            **임시 해결책**: `localStorage.clear()` 호출하면 해결됩니다.
            """
        ),
        
        // 4. 다중 이미지
        CommentItem(
            id: "4",
            author: "tester456",
            avatarURL: nil,
            createdAt: Date(),
            originalContent: """
            테스트 결과입니다:
            
            ![테스트1](https://example.com/test1.png)
            ![테스트2](https://example.com/test2.png)
            ![테스트3](https://example.com/test3.png)
            
            모든 테스트 **통과**했습니다! 🎉
            """
        ),
        
        // 5. 빈 텍스트 + 이미지
        CommentItem(
            id: "5",
            author: "reviewer789",
            avatarURL: nil,
            createdAt: Date(),
            originalContent: "![결과](https://example.com/result.png)"
        )
    ]
}
