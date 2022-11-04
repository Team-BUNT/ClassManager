//
//  Date.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/04.
//
import Foundation

extension Date {
    // MARK: "현재 시간 - 현재 시간 + n분" string 반환 함수
    func timeRangeString(interval: Int) -> String {
        let dateFormatter = DateFormatter() // Date 포맷 객체 선언
        dateFormatter.locale = Locale(identifier: "ko") // 한국 지정
        dateFormatter.dateFormat = "HH:mm" // 24:00 시간
        
        let startTime = dateFormatter.string(from: self) // 시작 시간
        let endTime = dateFormatter.string(from: Calendar.current.date(byAdding: .minute, value: interval, to: self) ?? self) // 종료 시간
        
        return "\(startTime) - \(endTime)"
    }
}
