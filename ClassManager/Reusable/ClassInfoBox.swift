//
//  ClassInfoBox.swift
//  ClassManager
//
//  Created by SeongHoon Jang on 2022/10/12.
//

import SwiftUI

struct ClassInfoBox: View {
    @State var danceClass: Class
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Hall \(danceClass.hall?.name ?? "A")")
                    .font(.subheadline)
                
                HStack(spacing: 3) {
                    Text(danceClass.instructorName ?? "댄서님")
                        .font(.custom(FontManager.Montserrat.semibold, size: 16))
                        .foregroundColor(.white)
                    Text("의 \(danceClass.title ?? "클래스")")
                        .foregroundColor(.white)
                        .font(.callout)
                }
                
                HStack(spacing: 4) {
                    Text(dateTo24Hour(date: danceClass.date))
                        .font(.subheadline)
                    Text("-")
                    
                    Text(dateTo24Hour(date: addMinute(date: danceClass.date, minute: danceClass.durationMinute)))
                        .font(.subheadline)
                }
                
                
                Divider()
                    .padding(.top, 15)
            }
            
            
            Image(systemName: "chevron.right")
                .font(.callout)
        }
        .foregroundColor(Color("Gray"))
        .padding(.top, 15)
        
    }
    
    // MARK: 24시간 형태로 시간을 반환
    private func dateTo24Hour(date: Date?) -> String {
        let dateFormatter = DateFormatter() // Date 포맷 객체 선언
        dateFormatter.locale = Locale(identifier: "ko") // 한국 지정
        dateFormatter.dateFormat = "HH:mm" // 24:00 시간
        let tiemString = dateFormatter.string(from: date ?? Date()) // 포맷된 형식 문자열로 반환
        
        return tiemString
    }
    
    // MARK: Date에 Minute를 추가
    private func addMinute(date: Date?, minute: Int?) -> Date?{
        return Calendar.current.date(
            byAdding: .minute,
            value: minute ?? 0,
            to: date ?? Date()
        )
    }
}

struct ClassInfoBox_Previews: PreviewProvider {
    static var previews: some View {
        ClassInfoBox(danceClass: Class(ID: "", studioID: nil, title: nil, instructorName: nil, date: Date(), durationMinute: nil, hall: nil, applicantsCount: nil))
    }
}
