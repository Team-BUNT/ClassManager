//
//  Student.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/04.
//

import Foundation

struct Student: Codable {
    let ID: String
    let studioID: String?
    let phoneNumber: String?
    let subPhoneNumber: String?
    let name: String?
    let enrollments: [Enrollment]
    let coupons: [Coupon]
    
    struct Coupon: Codable {
        let studioID: String?
        let studentID: String?
        let expiredDate: Date?
    }
    
    lazy var paid: Bool = getPaymentStatus()
    
    private func getPaymentStatus() -> Bool {
        for enrollment in enrollments {
            if !(enrollment.paid ?? false) {
                return false
            }
        }
        
        return true
    }
}
