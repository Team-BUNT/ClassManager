//
//  SuspendedClass.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/04.
//

import Foundation

class SuspendedClasses {
    static let shared = SuspendedClasses()
    var IDs = [String]()
    var studioID = ""
    
    private init() {}
}
