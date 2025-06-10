//
//  UIView+.swift
//  LetsGitIt
//
//  Created by KimRin on 6/10/25.
//

import UIKit

extension UIView {
    //StackView 사이의 공백뷰 넣는 
    static func createSpacerView(height: CGFloat) -> UIView {
       let spacer = UIView()
       spacer.translatesAutoresizingMaskIntoConstraints = false
       spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
       return spacer
   }

}
