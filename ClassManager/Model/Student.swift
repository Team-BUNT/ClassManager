//
//  Student.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/04.
//

import Foundation

struct Student {
    let ID: String
    let subPhoneNumber: String? = nil
    let name: String?
    let enrollments: [String]
    let coupons: [Coupon]
    
    struct Coupon {
        let studioID: String?
        let expiredDate: Date?
    }
}
