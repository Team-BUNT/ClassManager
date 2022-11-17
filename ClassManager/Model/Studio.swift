//
//  Studio.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/10/12.
//

import Foundation

struct Studio: Codable {
    let ID: String
    let name: String?
    let location: String?
    let notice: Notice?
    let halls: [Hall]?
    let email: String?
}
