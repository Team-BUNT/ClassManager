//
//  Constant.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/10/12.
//

import Foundation

class Constant {
    static let shared = Constant()
    
    var studio: Studio?
    var classes: [Class]?
    var suspendedClasses: SuspendedClasses?
    
    func isSuspended(classID: String) -> Bool {
        if suspendedClasses?.IDs != nil {
            return suspendedClasses!.IDs!.contains(classID)
        }
        return false
    }
    
    func repetitionNumber(repetition: Int) -> Int {
        switch repetition {
        case 0: return 2
        case 1: return 3
        case 2: return 4
        case 3: return 5
        case 4: return 6
        default: return 0
        }
    }
}
