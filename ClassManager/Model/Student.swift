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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ID = try container.decode(String.self, forKey: .ID)
        self.studioID = try container.decodeIfPresent(String.self, forKey: .studioID)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.subPhoneNumber = try container.decodeIfPresent(String.self, forKey: .subPhoneNumber)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.enrollments = try container.decode([Enrollment].self, forKey: .enrollments)
        self.coupons = try container.decode([Student.Coupon].self, forKey: .coupons)
    }
    
    var paid: Bool {
        for enrollment in enrollments {
            if !(enrollment.paid ?? false) {
                return false
            }
        }
        
        return true
    }
}
