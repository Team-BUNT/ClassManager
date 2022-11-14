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
        case 5: return 7
        case 6: return 8
        default: return 0
        }
    }
    
    func isClassRedundant(startTime: Date, interval: Int, hallName: String) -> Bool {
        if classes != nil {
            var filteredClasses = classes!.filter({ $0.date != nil && ((startTime > $0.date! && startTime < $0.date!.endTime(interval: $0.durationMinute ?? 0)) || (startTime.endTime(interval: interval) > $0.date! && startTime.endTime(interval: interval) < $0.date!.endTime(interval: $0.durationMinute ?? 0)) || (startTime < $0.date! && startTime.endTime(interval: interval) > $0.date!.endTime(interval: $0.durationMinute ?? 0))) })
            filteredClasses = filteredClasses.filter({ $0.hall != nil && $0.hall!.name == hallName && !isSuspended(classID: $0.ID) })
            if filteredClasses.count > 0 {
                return true
            }
        }
        return false
    }
}
