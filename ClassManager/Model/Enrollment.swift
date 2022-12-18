//
//  Enrollment.swift
//  ClassManager
//
//  Created by 김남건 on 2022/10/12.
//

import Foundation
import FirebaseFirestore

class Enrollment: Codable {
    let ID: String
    let classID: String?
    let studioID: String?
    let userName: String?
    let phoneNumber: String?
    let enrolledDate: Date?
    var paid: Bool?
    let paymentType: String?
    var attendance: Bool?
    let info: String?
    var matchedClass: Class? = nil
    var isRefunded: Bool?
    var refundReason: String?
    
    init(ID: String, classID: String?, studioID: String?, userName: String?, phoneNumber: String?, enrolledDate: Date?, paid: Bool?, paymentType: String? = nil, attendance: Bool? = nil, info: String? = nil, isRefunded: Bool?, refundReason: String?) {
        self.ID = ID
        self.classID = classID
        self.studioID = studioID
        self.userName = userName
        self.phoneNumber = phoneNumber
        self.enrolledDate = enrolledDate
        self.paid = paid
        self.paymentType = paymentType
        self.attendance = attendance
        self.info = info
        self.isRefunded = isRefunded
        self.refundReason = refundReason
    }
    
    init(documentSnapShot: DocumentSnapshot) {
        self.ID = documentSnapShot["ID"] as? String ?? ""
        self.classID = documentSnapShot["classID"] as? String
        self.studioID = documentSnapShot["studioID"] as? String
        self.userName = documentSnapShot["userName"] as? String
        self.phoneNumber = documentSnapShot["phoneNumber"] as? String
        self.enrolledDate = (documentSnapShot["enrolledDate"] as? Timestamp)?.dateValue() ?? Date()
        self.paid = documentSnapShot["paid"] as? Bool
        self.paymentType = documentSnapShot["paymentType"] as? String
        self.attendance = documentSnapShot["attendance"] as? Bool
        self.info = documentSnapShot["info"] as? String
    }
    
    func findClass(in classes: [Class]) {
        matchedClass = classes.filter { $0.ID == self.classID }.first
    }
    
    func isRefundedInServer(coupons: [Coupon]) -> Bool {
        coupons.filter { $0.classID == self.classID }.isEmpty
    }
}
