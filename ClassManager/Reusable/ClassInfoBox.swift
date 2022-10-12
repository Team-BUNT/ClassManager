//
//  ClassInfoBox.swift
//  ClassManager
//
//  Created by SeongHoon Jang on 2022/10/12.
//

import SwiftUI

struct ClassInfoBox: View {
    @Binding var danceClass: Class
    var body: some View {
        VStack {
            HStack {
                Text(danceClass.hall?.name ?? "연습실")
                    .font(.subheadline)
                
                Spacer()
                
                Text(get24Hour(date: danceClass.date))
            }
            
            HStack {
                Text(danceClass.instructorName ?? "댄서님")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Text("의 \(danceClass.title ?? "클래스")")
                    .foregroundColor(.white)
                    .font(.callout)
                
                Spacer()
                
                Text(get24Hour(date: addMinute(date: danceClass.date, minute: danceClass.durationMinute)))
            }
        }
        .foregroundColor(.gray)
        
            
    }
    
    // MARK: 24시간 형태로 시간을 반환
    func get24Hour(date: Date?) -> String {
        let dateFormatter = DateFormatter() // Date 포맷 객체 선언
        dateFormatter.locale = Locale(identifier: "ko") // 한국 지정
        dateFormatter.dateFormat = "kk:mm" // 24:00 시간
        let tiemString = dateFormatter.string(from: date ?? Date()) // 포맷된 형식 문자열로 반환

        return tiemString
    }
    
    // MARK: Date에 Minute를 추가
    func addMinute(date: Date?, minute: Int?) -> Date?{
        return Calendar.current.date(
            byAdding: .minute,
            value: minute ?? 0,
            to: date ?? Date()
        )
    }
}

