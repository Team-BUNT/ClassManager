//
//  Class.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/10/12.
//

import Foundation

struct Class: Codable {
    let ID: String
    let studioID: String?
    let title: String?
    let instructorName: String?
    let date: Date?
    let durationMinute: Int?
    let hall: Hall?
    let applicantsCount: Int?
    let isPopUp: Bool? = nil
}
