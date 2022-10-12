//
//  ClassCalendarView.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/10/12.
//

import SwiftUI

struct ClassCalendarView: View {
    @State private var date = Date()
    @State var dummyClass = Class(
        ID: "classID",
        studioID: "studioID",
        title: "팝업 클래스",
        instructorName: "Narae",
        date: Calendar.current.date(
            from: DateComponents(year:2022, month: 10, day: 14, hour: 20, minute: 0)
        ),
        durationMinute: 60,
        hall: Hall(name: "Hall A", capacity: 40),
        applicantsCount: 30
    )
    
    var body: some View {
        
        VStack {
            DatePicker(
                "Pick a class date",
                selection: $date,
                displayedComponents: [.date]
            )
            .padding()
            .datePickerStyle(.graphical)
            .accentColor(Color("Del"))
            .background(
                Color("Box"),
                in: RoundedRectangle(cornerRadius: 13)
            ).padding(.bottom, 10)
            
            
            ScrollView {
                NavigationLink(
                    destination: Text("asdf"),
                    label: {
                        ClassInfoBox(danceClass: $dummyClass)
                    })
                Divider()
                
                NavigationLink(
                    destination: Text("asdf"),
                    label: {
                        ClassInfoBox(danceClass: $dummyClass)
                    })
                Divider()
                
                NavigationLink(
                    destination: Text("asdf"),
                    label: {
                        ClassInfoBox(danceClass: $dummyClass)
                    })
                Divider()
                
            }
            
            
            Spacer()
        }
        .padding()
        .navigationTitle("CLASS 관리")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    print("링크 복사하기")
                } label: {
                    Image(systemName: "personalhotspot")
                        .foregroundColor(.white)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
            }
        }
    }
}

struct ClassCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ClassCalendarView()
    }
}
