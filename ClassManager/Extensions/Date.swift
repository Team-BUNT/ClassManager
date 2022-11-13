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
    
    // MARK: 원하는 format만 주입하면 string 반환
    func formattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    // MARK: "일" 단위 까지만 비교하여 날짜 간격 계산
    func dateGap(from start: Date) -> Int {
        let timeInterval = Int(self.timeIntervalSince1970 / 86400)
        let startTimeInterval = Int(start.timeIntervalSince1970 / 86400)
        
        return timeInterval - startTimeInterval + 1
    }
}
