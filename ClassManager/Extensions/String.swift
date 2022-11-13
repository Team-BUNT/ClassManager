//
//  String.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/12.
//

import Foundation

extension String {
    func toPhoneNumberFormat() -> String {
        var phoneNumberString = self
        phoneNumberString.insert(" ", at: phoneNumberString.index(phoneNumberString.startIndex, offsetBy: 3))
        phoneNumberString.insert(" ", at: phoneNumberString.index(phoneNumberString.startIndex, offsetBy: 8))
        return phoneNumberString
    }
}
