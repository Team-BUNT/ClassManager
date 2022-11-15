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
    
    // MARK: interval 분 뒤의 date 객체 반환
    func endTime(interval: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: interval, to: self) ?? self
    }
    
    // MARK: 캘린더의 컴포넌트를 가져오는 extension(eg. Date().get(.month) -> 오늘 날짜에 해당하는 월 반환)
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
