//
//  WeeklyCalendarView.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/15.
//

import SwiftUI

struct WeeklyCalendarView: View {
    @State var date = Date()
    @State var month = 13
    
    let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .center, spacing: 12) {
                Text("\(month)월")
                    .font(.montserrat(.semibold, size: 28))
                Spacer()
                Image(systemName: "chevron.backward")
                    .contentShape(Rectangle())
                    .onTapGesture {
                        date = Calendar.current.date(byAdding: .day, value: -7, to: date)!
                        month = monthNumber()
                    }
                Image(systemName: "chevron.forward")
                    .contentShape(Rectangle())
                    .onTapGesture {
                        date = Calendar.current.date(byAdding: .day, value: 7, to: date)!
                        month = monthNumber()
                    }
            }
            .font(.system(size: 20))
            ForEach(0..<7, id: \.self) { idx in
                HStack {
                    VStack {
                        Text(weekdays[idx])
                        Text(dayNumberString(weekday: idx))
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            month = monthNumber()
        }
    }
    
    private func dayNumberString(weekday: Int) -> String {
        let currentWeekday = date.get(.weekday) == 1 ? 6 : date.get(.weekday) - 2
        let calculatedDate = Calendar.current.date(byAdding: .day, value: weekday - currentWeekday, to: date)
        return String(calculatedDate!.get(.day))
    }
    
    private func monthNumber() -> Int {
        let currentWeekday = date.get(.weekday) == 1 ? 6 : date.get(.weekday) - 2
        let monday = Calendar.current.date(byAdding: .day, value: -currentWeekday, to: date)
        return monday?.get(.month) ?? 13
    }
}

struct WeeklyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyCalendarView()
    }
}
