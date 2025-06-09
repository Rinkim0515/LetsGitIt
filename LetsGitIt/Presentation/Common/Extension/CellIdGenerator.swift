//
//  CellID.swift
//  LetsGitIt
//
//  Created by KimRin on 6/9/25.
//

import Foundation

protocol CellIdGenerator: AnyObject {
    static var id: String { get }
}

extension CellIdGenerator {
    static var id: String {
        return String(describing: self)
    }
}
