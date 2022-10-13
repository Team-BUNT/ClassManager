//
//  Enrollment.swift
//  ClassManager
//
//  Created by 김남건 on 2022/10/12.
//

import Foundation
import FirebaseFirestore

struct Enrollment {
    let ID: String
    let classID: String?
    let number: Int?
    let userName: String?
    let phoneNumber: String?
    let enrolledDate: Date?
    let paid: Bool?
    
    init(ID: String, classID: String?, number: Int?, userName: String?, phoneNumber: String?, enrolledDate: Date?, paid: Bool?) {
        self.ID = ID
        self.classID = classID
        self.number = number
        self.userName = userName
        self.phoneNumber = phoneNumber
        self.enrolledDate = enrolledDate
        self.paid = paid
    }
    
    init(documentSnapShot: DocumentSnapshot) {
        self.ID = documentSnapShot["ID"] as? String ?? ""
        self.classID = documentSnapShot["classID"] as? String
        self.number = documentSnapShot["number"] as? Int
        self.userName = documentSnapShot["userName"] as? String
        self.phoneNumber = documentSnapShot["phoneNumber"] as? String
        self.enrolledDate = (documentSnapShot["enrolledDate"] as? Timestamp)!.dateValue()
        self.paid = documentSnapShot["paid"] as? Bool
    }
}
