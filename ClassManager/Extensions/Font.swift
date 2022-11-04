//
//  Font.swift
//  ClassManager
//
//  Created by SeongHoon Jang on 2022/11/04.
//

import SwiftUI

extension Font {
    enum Montserrat {
        case semibold
        
        var value: String {
            switch self {
            case .semibold:
                return "Montserrat-SemiBold"
            }
        }
    }

    static func montserrat(_ type: Montserrat, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
}
