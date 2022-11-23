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
    var enrollments: [Enrollment]
    var coupons: [Coupon]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ID = try container.decode(String.self, forKey: .ID)
        self.studioID = try container.decodeIfPresent(String.self, forKey: .studioID)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.subPhoneNumber = try container.decodeIfPresent(String.self, forKey: .subPhoneNumber)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.enrollments = try container.decode([Enrollment].self, forKey: .enrollments)
        self.coupons = try container.decode([Coupon].self, forKey: .coupons)
    }
    
    init(ID: String, studioID: String?, phoneNumber: String?, subPhoneNumber: String?, name: String?, enrollments: [Enrollment]?, coupons: [Coupon]?) {
        self.ID = ID
        self.studioID = studioID
        self.phoneNumber = phoneNumber
        self.subPhoneNumber = subPhoneNumber
        self.name = name
        self.enrollments = enrollments ?? []
        self.coupons = coupons ?? []
    }
    
    // MARK: enrollment 중 단 하나라도 paid가 false라면 false 반환
    var paid: Bool {
        for enrollment in enrollments {
            if !(enrollment.paid ?? false) {
                return false
            }
        }
        
        return true
    }
    
    // MARK: 기한이 지나지 않고 클래스 신청에 사용되지 않은 coupon들을 리턴
    var availableCoupons: [Coupon] {
        coupons
            .filter({
                guard let date = $0.expiredDate, date.dateGap(from: .now) >= 0 else {
                    return false
                }
                
                return $0.classID == nil
            })
            .sorted(by: {
                if $0.expiredDate != $1.expiredDate {
                    return $0.expiredDate ?? Date() < $1.expiredDate ?? Date()
                }
                
                return !($0.isFreePass ?? false) && ($1.isFreePass ?? false)
            })
    }
    
    // MARK: coupon을 날짜와 프리패스 여부가 같은 것끼리 grouping함
    var groupedCoupons: [[Coupon]] {
        var grouped = [[Coupon]]()
        var temp = [Coupon]()
        
        for coupon in availableCoupons {
            if temp.isEmpty ||
                (temp.last!.expiredDate?.formattedString(format: "yyyy.MM.dd") == coupon.expiredDate?.formattedString(format: "yyyy.MM.dd") &&
                 temp.last!.isFreePass == coupon.isFreePass) {
                temp.append(coupon)
            } else {
                grouped.append(temp)
                temp = [coupon]
            }
        }
        
        if !temp.isEmpty {
            grouped.append(temp)
        }
        
        return grouped
    }
}
