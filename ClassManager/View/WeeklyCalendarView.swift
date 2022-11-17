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
    
    let classes = Constant.shared.classes
    
    var body: some View {
        VStack(spacing: 40) {
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
            HStack {
                VStack {
                    ForEach(0..<7, id: \.self) { idx in
                        VStack {
                            Text(weekdays[idx])
                            Text(dayNumberString(weekday: idx))
                        }
                        Spacer()
                    }
                }
                .padding(.vertical)
                ScrollView(.horizontal) {
                    VStack(alignment: .leading, spacing: 40) {
                        ForEach(0..<7, id: \.self) { idx in
                            HStack {
                                ForEach(classesOnDay(day: dayOfWeek(weekday: idx)), id: \.self.ID) { danceClass in
                                    VStack {
                                        Text(danceClass.title ?? "")
                                        Text(danceClass.instructorName ?? "")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            month = monthNumber()
        }
    }
    
    private func dayOfWeek(weekday: Int) -> Date {
        let currentWeekday = date.get(.weekday) == 1 ? 6 : date.get(.weekday) - 2
        return Calendar.current.date(byAdding: .day, value: weekday - currentWeekday, to: date) ?? Date()
    }
    
    private func dayNumberString(weekday: Int) -> String {
        return String(dayOfWeek(weekday: weekday).get(.day))
    }
    
    private func monthNumber() -> Int {
        let currentWeekday = date.get(.weekday) == 1 ? 6 : date.get(.weekday) - 2
        let monday = Calendar.current.date(byAdding: .day, value: -currentWeekday, to: date)
        return monday?.get(.month) ?? 13
    }
    
    private func classesOnDay(day: Date) -> [Class] {
        return classes?.filter({ Calendar.current.isDate($0.date ?? Date(), inSameDayAs: day) }) ?? [Class]()
    }
}

struct WeeklyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyCalendarView()
    }
}
