//
//  Coupon.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/22.
//

import Foundation

class Coupon: Codable {
    let studioID: String?
    let studentID: String?
    let isFreePass: Bool?
    let expiredDate: Date?
    var classID: String?
}
