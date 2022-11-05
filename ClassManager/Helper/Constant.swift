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
}
