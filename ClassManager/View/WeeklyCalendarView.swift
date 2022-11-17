//
//  WeeklyCalendarView.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/15.
//

import SwiftUI

struct WeeklyCalendarView: View {
    @Binding var date: Date
    
    let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    @State var classes = Constant.shared.classes
    @Binding var isShowingSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            viewHeader
            GeometryReader { proxy in
                HStack(alignment: .top) {
                    VStack {
                        ForEach(0..<7, id: \.self) { idx in
                            VStack(spacing: 8) {
                                Text(weekdays[idx])
                                    .font(.montserrat(.regular, size: 14))
                                Text(dayNumberString(weekday: idx))
                                    .kerning(1.6)
                                    .font(.montserrat(.semibold, size: 16))
                            }
                            .frame(height: (proxy.size.height - 14 * 6) / 7)
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(0..<7, id: \.self) { idx in
                                if let dayClasses = classesOnDay(day: dayOfWeek(weekday: idx)) {
                                    HStack(spacing: 14) {
                                        if dayClasses.count > 0 {
                                            ForEach(dayClasses, id: \.self.ID) { danceClass in
                                                NavigationLink(destination: AttendanceView(currentClass: danceClass)) {
                                                    classCardView(danceClass: danceClass)
                                                        .frame(height: (proxy.size.height - 14 * 6) / 7)
                                                }
                                            }
                                        } else {
                                            Rectangle()
                                                .frame(height: (proxy.size.height - 14 * 6) / 7)
                                                .foregroundColor(Color("Box"))
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
                .padding(.leading, 19)
            }
            .padding(.bottom, -16)
        }
        .padding(.top, 4)
        .padding(.leading, 18)
        .background(RoundedRectangle(cornerRadius: 14).padding(.leading, 18).padding(.trailing, -18).padding(.top, 4).foregroundColor(Color("Box")))
        .onAppear {
            classes = Constant.shared.classes
            date = dayOfWeek(weekday: 0)
        }
        .onChange(of: isShowingSheet) { _ in
            classes = Constant.shared.classes
        }
    }
    
    var viewHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                Text("\(dayOfWeek(weekday: 6).monthName) \(String(dayOfWeek(weekday: 6).get(.year)))")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "chevron.backward")
                    .contentShape(Rectangle())
                    .onTapGesture {
                        date = Calendar.current.date(byAdding: .day, value: -7, to: date)!
                        date = dayOfWeek(weekday: 0)
                    }
                Image(systemName: "chevron.forward")
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .padding(.trailing, 10)
                    .onTapGesture {
                        date = Calendar.current.date(byAdding: .day, value: 7, to: date)!
                        date = dayOfWeek(weekday: 0)
                    }
            }
            .padding(.leading, 18)
            .padding(.top, 10)
            .font(.system(size: 20))
            
            HStack(spacing: 6) {
                Text("POP-UP")
                    .font(.system(size: 13))
                popupTag
            }
            .padding(.leading, 19)
            .padding(.bottom, 12)
        }
    }
    
    var popupTag: some View {
        Circle().foregroundColor(Color("Accent")).frame(width: 9, height: 9)
    }
    
    private func dayOfWeek(weekday: Int) -> Date {
        let currentWeekday = date.get(.weekday) == 1 ? 6 : date.get(.weekday) - 2
        return Calendar.current.date(byAdding: .day, value: weekday - currentWeekday, to: date) ?? Date()
    }
    
    private func dayNumberString(weekday: Int) -> String {
        let dayNum = dayOfWeek(weekday: weekday).get(.day)
        return dayNum < 10 ? "0" + String(dayNum) : String(dayNum)
    }
    
    private func monthNumber() -> Int {
        let currentWeekday = date.get(.weekday) == 1 ? 6 : date.get(.weekday) - 2
        let monday = Calendar.current.date(byAdding: .day, value: -currentWeekday, to: date)
        return monday?.get(.month) ?? 13
    }
    
    private func classesOnDay(day: Date) -> [Class] {
        var filteredClasses = classes?.filter({ Calendar.current.isDate($0.date ?? Date(), inSameDayAs: day) }) ?? [Class]()
        filteredClasses.sort { $0.date ?? Date() < $1.date ?? Date() }
        return filteredClasses
    }
    
    struct classCardView: View {
        let danceClass: Class
        
        var body: some View {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Hall \(danceClass.hall?.name ?? "")")
                            .foregroundColor(Color("Gray"))
                        Spacer()
                        Text(danceClass.date?.timeString() ?? "")
                            .foregroundColor(Color("DarkGray"))
                    }
                    .font(.system(size: 15))
                    Spacer()
                    HStack {
                        Text(danceClass.instructorName ?? "")
                            .font(.montserrat(.semibold, size: 16))
                            .foregroundColor(Constant.shared.isSuspended(classID: danceClass.ID) ? Color("DarkGray") : .white)
                            .strikethrough(Constant.shared.isSuspended(classID: danceClass.ID))
                        if danceClass.isPopUp ?? false {
                            Circle().foregroundColor(Color("Accent")).frame(width: 9, height: 9)
                        }
                    }
                }
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.black).frame(width: 119))
                .frame(width: 119)
        }
    }
}
