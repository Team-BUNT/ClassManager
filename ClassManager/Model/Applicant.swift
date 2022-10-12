//
//  File.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/10/12.
//

import Foundation

struct Applicant: Codable {
    let timestamp: Date?
    let classID: String?
    let name: String?
    let phoneNumber: String?
    let couponType: Int?
}
