//
//  Encodable.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/08.
//

import Foundation
import Firebase

extension Enrollment {
    func encode() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard var dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        
        dictionary["enrolledDate"] = Timestamp(date: enrolledDate ?? Date())
        
        return dictionary
    }
}

extension Array where Element: Enrollment {
    func encode() throws -> [[String: Any]] {
        return try self.map { try $0.encode() }
    }
}

extension Coupon {
    func encode() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard var dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        
        dictionary["expiredDate"] = Timestamp(date: expiredDate ?? Date())
        return dictionary
    }
}

extension Array where Element: Coupon {
    func encode() throws -> [[String: Any]] {
        return try self.map { try $0.encode() }
    }
}
